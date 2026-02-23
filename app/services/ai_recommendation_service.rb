class AiRecommendationService
  def initialize(user)
    @user = user
    
    # Load .env if not already loaded
    require 'dotenv/load' unless ENV['ANTHROPIC_API_KEY'].present?
    
    # Get API key from environment
    api_key = ENV['ANTHROPIC_API_KEY']
    
    if api_key.blank?
      Rails.logger.error("ANTHROPIC_API_KEY not found in environment variables")
      raise "Anthropic API key not configured"
    end
    
    @client = Anthropic::Client.new(access_token: api_key)
  end

  def generate_recommendations
    bookmarked_listings = @user.bookmarked_listings
    all_listings = Listing.where.not(id: bookmarked_listings.pluck(:id))

    return { recommendations: [], summary: nil, success: false } if bookmarked_listings.empty? || all_listings.empty?

    # Prepare data for Claude
    bookmarked_data = prepare_listing_data(bookmarked_listings)
    available_data = prepare_listing_data(all_listings)

    # Call Claude API
    response = @client.messages(
      parameters: {
        model: "claude-sonnet-4-20250514",
        max_tokens: 3000,
        messages: [
          {
            role: "user",
            content: build_recommendation_prompt(bookmarked_data, available_data)
          }
        ]
      }
    )

    # Parse response
    parse_recommendations(response, all_listings)
  rescue => e
    Rails.logger.error("AI Recommendation Error: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    { recommendations: [], summary: "Unable to generate recommendations at this time.", success: false }
  end

  private

  def prepare_listing_data(listings)
    listings.map do |listing|
      {
        id: listing.id,
        title: listing.title,
        description: listing.description,
        city: listing.city,
        state: listing.state,
        price: listing.price.to_f,
        bedrooms: listing.bedrooms,
        bathrooms: listing.bathrooms.to_f,
        square_feet: listing.square_feet
      }
    end
  end

  def build_recommendation_prompt(bookmarked, available)
    <<~PROMPT
      You are a real estate recommendation expert. Analyze a user's bookmarked listings and recommend similar properties they might like.

      USER'S BOOKMARKED LISTINGS:
      #{JSON.pretty_generate(bookmarked)}

      AVAILABLE LISTINGS TO RECOMMEND FROM:
      #{JSON.pretty_generate(available)}

      YOUR TASK:
      1. Analyze the user's preferences based on their bookmarked listings (price range, location, size, bedrooms, style) and their bio if available.
      2. Find 3-5 listings from the available listings that match their preferences
      3. For each recommendation, explain WHY you think they'll like it based on their bookmarks
      4. Write in a friendly, personalized tone

      Return ONLY valid JSON in this exact format (no markdown, no additional text):
      {
        "recommendations": [
          {
            "listing_id": 5,
            "reason": "This charming 2-bedroom in Oak Park is similar to your bookmarked Victorian apartment. It features the same historic charm with modern updates, and it's in your preferred $2,000-$2,500 price range.",
            "match_score": 95
          }
        ],
        "summary": "Based on your bookmarks, you seem to prefer historic properties with character in the $2,000-$2,500 range, particularly in Chicago neighborhoods with good transit access."
      }

      Provide 3-5 recommendations, ordered by match_score (highest first).
    PROMPT
  end

  def parse_recommendations(response, all_listings)
    begin
      content = response.dig("content", 0, "text")
      
      # Remove markdown code blocks if present
      content = content.gsub(/```json\n?/, '').gsub(/```\n?/, '').strip
      
      # Parse the JSON
      result = JSON.parse(content)
      
      # Get the listing IDs
      listing_ids = result["recommendations"].map { |r| r["listing_id"] }
      
      # Fetch the actual listings and build recommendations
      recommendations = result["recommendations"].map do |rec|
        listing = all_listings.find { |l| l.id == rec["listing_id"] }
        next unless listing
        
        {
          listing: listing,
          reason: rec["reason"],
          match_score: rec["match_score"]
        }
      end.compact

      {
        recommendations: recommendations,
        summary: result["summary"],
        success: true
      }
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse AI response: #{e.message}")
      Rails.logger.error("Response content: #{content}")
      {
        recommendations: [],
        summary: "Unable to parse AI recommendations.",
        success: false
      }
    rescue => e
      Rails.logger.error("Unexpected error parsing recommendations: #{e.message}")
      {
        recommendations: [],
        summary: "An error occurred while processing recommendations.",
        success: false
      }
    end
  end
end
