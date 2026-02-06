class AiRecommendationService
  def initialize(user)
    @user = user
    @client = Anthropic::Client.new
  end

  def generate_recommendations
    bookmarked_listings = @user.bookmarked_listings.includes(:listing)
    all_listings = Listing.where.not(id: bookmarked_listings.pluck(:id))

    return nil if bookmarked_listings.empty? || all_listings.empty?

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
      1. Analyze the user's preferences based on their bookmarked listings (price range, location, size, bedrooms, style)
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
      content = content.gsub(/```json\n?/, '').gsub(/```\n?/, '').strip
      
      result = JSON.parse(content)
      
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
    rescue => e
      Rails.logger.error("Failed to parse AI recommendations: #{e.message}")
      {
        recommendations: [],
        summary: nil,
        success: false
      }
    end
  end
end
