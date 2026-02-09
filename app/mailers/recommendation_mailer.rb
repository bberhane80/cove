class RecommendationMailer < ApplicationMailer
  default from: "recommendations@cove.com"

  def weekly_recommendations(user)
    @user = user

    # Check if API key exists
    unless ENV["ANTHROPIC_API_KEY"].present?
      Rails.logger.error("Cannot send recommendations: ANTHROPIC_API_KEY not configured")
      return
    end

    # Generate AI recommendations
    begin
      service = AiRecommendationService.new(user)
      result = service.generate_recommendations
    rescue => e
      Rails.logger.error("Failed to generate recommendations for #{user.email}: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      return
    end

    return unless result && result[:success] && result[:recommendations].any?

    @recommendations = result[:recommendations]
    @summary = result[:summary]

    mail(
      to: @user.email,
      subject: "#{@user.username}, Cove found #{@recommendations.count} listings you might love! 🏡"
    )
  rescue => e
    Rails.logger.error("Failed to send recommendations to #{user.email}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end
end
