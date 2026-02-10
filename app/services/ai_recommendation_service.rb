class AiRecommendationService
  def initialize(user)
    @user = user

    # Get API key from environment
    api_key = ENV["ANTHROPIC_API_KEY"]
    if api_key.blank?
      Rails.logger.error("ANTHROPIC_API_KEY not found in environment variables")
      raise "Anthropic API key not configured"
    end

    @client = Anthropic::Client.new(access_token: api_key)
  end

  # ... rest of your code
end
