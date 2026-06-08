class ChatbotService
  def initialize(user)
    @user = user
    @client = Anthropic::Client.new(access_token: ENV["ANTHROPIC_API_KEY"])
    @retriever = ListingRetrievalService.new
  end

  def send_message(user_message, session)
    # Add user message to session
    session.add_message('user', user_message)

    retrieved_listings = @retriever.retrieve(user_message, top_k: 5)
    system_context = if retrieved_listings.any?
      system_prompt_with_retrieved_listings(retrieved_listings)
    else
      system_prompt
    end

    # Build conversation history
    conversation = build_conversation_history(session, limit: 12)

    # Get AI response
    response = @client.messages(
      parameters: {
        model: "claude-sonnet-4-20250514",
        max_tokens: 1500,
        system: system_context,
        messages: conversation
      }
    )

    # Extract assistant response
    assistant_message = response.dig('content', 0, 'text')

    # Add assistant message to session
    session.add_message('assistant', assistant_message)

    {
      success: true,
      message: assistant_message,
      session_id: session.id,
      listings: retrieved_listings.map { |entry| entry[:listing] }
    }
  rescue => e
    Rails.logger.error("Chatbot error: #{e.message}")
    {
      success: false,
      message: "I'm having trouble right now. Please try again later.",
      error: e.message
    }
  end

  private

def should_recommend_listings?(message, session)
  # Check if conversation has enough context for recommendations
  message_count = session.chat_messages.by_user.count
  
  keywords = ['show me', 'recommend', 'find', 'looking for', 'need', 'want', 'search']
  
  message_count >= 2 && keywords.any? { |kw| message.downcase.include?(kw) }
end

def extract_search_criteria(session)
  # Simple keyword extraction (could be enhanced with NLP)
  conversation_text = session.chat_messages.pluck(:content).join(' ').downcase
  
  criteria = {}
  
  # Extract budget
  if conversation_text.match(/\$?(\d{3,4})/)
    criteria[:max_price] = $1.to_i
  end
  
  # Extract bedrooms
  if conversation_text.match(/(\d)\s*(bed|br|bedroom)/)
    criteria[:bedrooms] = $1.to_i
  end
  
  # Extract city
  cities = ['chicago', 'evanston', 'oak park', 'naperville']
  cities.each do |city|
    criteria[:city] = city.titleize if conversation_text.include?(city)
  end
  
  criteria
end

def find_matching_listings(criteria)
  listings = Listing.all
  
  listings = listings.where('price <= ?', criteria[:max_price]) if criteria[:max_price]
  listings = listings.where(bedrooms: criteria[:bedrooms]) if criteria[:bedrooms]
  listings = listings.where(city: criteria[:city]) if criteria[:city]
  
  listings.limit(3)
end

  def system_prompt_with_listings(listings)
    listings_text = if listings.any?
      listings.map do |l|
        "- #{l.title} in #{l.city}: $#{l.price}/mo, #{l.bedrooms}br/#{l.bathrooms}ba, #{l.square_feet} sqft\n  Link: #{Rails.application.routes.url_helpers.listing_url(l, host: 'localhost:3000')}"
      end.join("\n")
    else
      "No exact matches found in our current inventory."
    end
    system_prompt + "\n\nCURRENT MATCHING LISTINGS:\n#{listings_text}"
  end

  def system_prompt_with_retrieved_listings(retrieved_listings)
    listing_context = retrieved_listings.map.with_index(1) do |entry, index|
      listing = entry[:listing]
      snippet = entry[:snippet]
      <<~LISTING
        LISTING #{index}
        ID: #{listing.id}
        TITLE: #{listing.title}
        CITY: #{listing.city}
        PRICE: $#{listing.price.to_i}
        BEDROOMS: #{listing.bedrooms}
        BATHROOMS: #{listing.bathrooms}
        SUMMARY: #{snippet}
        URL: #{Rails.application.routes.url_helpers.listing_url(listing, host: 'localhost:3000')}
      LISTING
    end.join("\n")

    <<~PROMPT
      #{system_prompt}

      Use the following listing information to answer the user's question. If the user asks for a recommendation, base your answer on these listings and do not invent other properties.

      RELEVANT LISTINGS:
      #{listing_context}
    PROMPT
  end

  def format_listing_snippet(listing)
    summary = [listing.title, listing.city, listing.neighborhood, listing.description].compact.join(' – ')
    summary.truncate(180)
  end

  # Stub for system_prompt if not defined elsewhere
  def system_prompt
    "You are Cove, a helpful real estate assistant."
  end

  # Stub for build_conversation_history if not defined elsewhere
  def build_conversation_history(session, limit: 12)
    session.chat_messages.order(:created_at).last(limit).map do |msg|
      { role: msg.role, content: msg.content }
    end
  end

end
