class SendRecommendationEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user&.receive_recommendations? && user.email_frequency.present?
    return unless ENV["ANTHROPIC_API_KEY"].present?

    mail = RecommendationMailer.weekly_recommendations(user)
    if mail.present?
      mail.deliver_now
      user.update!(last_recommendation_sent_at: Time.current)
    else
      Rails.logger.info("No recommendation email generated for user=#{user.email}")
    end
  rescue => e
    Rails.logger.error("SendRecommendationEmailJob failed for user_id=#{user_id}: #{e.class}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end
end
