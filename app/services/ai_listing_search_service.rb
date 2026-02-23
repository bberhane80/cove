class AiListingSearchService
  def initialize(query)
    @query = query
    
    # Get API key from environment
    api_key = ENV['ANTHROPIC_API_KEY']
    
    if api_key.blank?
      Rails.logger.error("ANTHROPIC_API_KEY not found in environment variables")
      raise "Anthropic API key not configured"
    end
    
    @client = Anthropic::Client.new(access_token: api_key)
  end

  def search
    # Get all listings with their attributes
    all_listings = Listing.all
    
    # Convert listings to a structured format for Claude
    listings_data = all_listings.map do |listing|
      {
        id: listing.id,
        title: listing.title,
        description: listing.description,
        address: listing.address,
        city: listing.city,
        state: listing.state,
        price: listing.price.to_f,
        bedrooms: listing.bedrooms,
        bathrooms: listing.bathrooms.to_f,
        square_feet: listing.square_feet
      }
    end

    # Call Claude to analyze the query and find matching listings
    response = @client.messages(
      parameters: {
        model: "claude-sonnet-4-20250514",
        max_tokens: 2000,
        messages: [
          {
            role: "user",
            content: build_prompt(listings_data)
          }
        ]
      }
    )

    # Parse Claude's response
    parse_response(response, all_listings)
  end

  private

  def build_prompt(listings_data)
    <<~PROMPT
      You are a real estate search assistant. A user is searching for rental listings with this query:
      <<~PROMPT
        You are a real estate search assistant. A user is searching for rental listings with this query:
      
        "#{@query}"
        Here are all available listings:
        #{JSON.pretty_generate(listings_data)}
      
        Your task:
        1. Understand what the user is looking for (location, price range, number of bedrooms, amenities, etc.)
        2. Return ONLY a JSON array of listing IDs that match their criteria, ordered by relevance (best matches first)
        3. If the user's query is vague, include listings that might be a good fit
      
        Return ONLY valid JSON in this exact format (no additional text):
        {
          "listing_ids": [1, 5, 3],
          "explanation": "Found 3 listings matching your criteria for 2-bedroom apartments in Chicago under $2000/month"
        }
      
        If no listings match, return:
        {
          "listing_ids": [],
          "explanation": "No listings found matching your criteria. Try adjusting your search."
        }
      PROMPT

  def parse_response(response, all_listings)
    begin
      # Extract the text content from Claude's response
      content = response.dig("content", 0, "text")
      if content.blank?
        Rails.logger.error("AI response content is blank or missing")
        return {
          listings: [],
          explanation: "Sorry, I couldn't process that search. Please try again.",
          success: false
        }
      end
      # Remove markdown code blocks if present
      content = content.gsub(/```json\n?/, '').gsub(/```\n?/, '').strip
      # Parse the JSON
      result = JSON.parse(content)
      # Get the listing IDs
      listing_ids = result["listing_ids"]
      explanation = result["explanation"]
      unless listing_ids.is_a?(Array)
        Rails.logger.error("AI response missing listing_ids array")
        return {
          listings: [],
          explanation: "Sorry, I couldn't process that search. Please try again.",
          success: false
        }
      end
      # Fetch the actual listings in the order specified by Claude
      ordered_listings = listing_ids.map do |id|
        all_listings.find { |l| l.id == id }
      end.compact
      {
        listings: ordered_listings,
        explanation: explanation,
        success: true
      }
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse AI response: #{e.message}")
      {
        listings: [],
        explanation: "Sorry, I couldn't process that search. Please try again.",
        success: false
      }
    end
  end
end
