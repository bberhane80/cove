class ChatbotService
  def initialize(user)
    @user = user
    @client = Anthropic::Client.new(access_token: ENV["ANTHROPIC_API_KEY"])
  end

  def send_message(user_message, session)
    # Add user message to session
    session.add_message("user", user_message)

    # Build conversation history
    conversation = build_conversation_history(session)

    # Get AI response
    response = @client.messages(
      parameters: {
        model: "claude-sonnet-4-20250514",
        max_tokens: 1000,
        system: system_prompt,
        messages: conversation
      }
    )
    
    # Extract assistant response
    assistant_message = response.dig("content", 0, "text")
    
    # Add assistant message to session
    session.add_message('assistant', assistant_message)
    
    {
      success: true,
      message: assistant_message,
      session_id: session.id
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
  
  def system_prompt
    <<~PROMPT
      You are Cove's AI assistant, helping users find their perfect rental apartment.
      
      Your role:
      - Ask clarifying questions about budget, location preferences, lifestyle, and must-haves
      - Be conversational, friendly, and helpful
      - Keep responses concise (2-3 sentences max)
      - After gathering info, provide specific recommendations
      - Use the user's name (#{@user.username}) when appropriate
      
      User context:
      - Username: #{@user.username}
      - Email: #{@user.email}
      - Bio: #{@user.bio.presence || 'Not provided'}
      - Bookmarked listings: #{@user.bookmarks.count}
      
      Guidelines:
      - Start by asking about their budget if not mentioned
      - Ask about preferred neighborhoods/cities
      - Inquire about must-have amenities (parking, pets, etc.)
      - Ask about lifestyle (commute, nightlife, quiet, family-friendly)
      - Suggest listings based on their responses
      - Keep a warm, helpful tone
      
      Example flow:
      1. "Hi #{@user.username}! I'm here to help you find your perfect apartment. What's your budget range?"
      2. "Great! Where are you looking to live? Any specific neighborhoods or cities?"
      3. "What's most important to you in an apartment? (e.g., natural light, modern kitchen, outdoor space)"
      4. Based on answers, recommend specific listings from our database
    PROMPT
  end
  
  def build_conversation_history(session)
    messages = []
    
    session.chat_messages.order(:created_at).each do |msg|
      next if msg.role == 'system'
      messages << { role: msg.role, content: msg.content }
    end
    
    messages
  end
end
