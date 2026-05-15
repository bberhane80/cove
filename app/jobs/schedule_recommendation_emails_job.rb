class ScheduleRecommendationEmailsJob < ApplicationJob
  queue_as :default

  def perform(date = Date.current)
    User.recommendation_recipients.find_each do |user|
      next unless user.due_for_recommendations?(date)

      SendRecommendationEmailJob.perform_later(user.id)
    end
  rescue => e
    Rails.logger.error("ScheduleRecommendationEmailsJob failed: #{e.class}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end
end
