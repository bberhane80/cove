namespace :recommendations do
  desc "Send daily personalized recommendations to users"
  task send_daily: :environment do
    send_recommendations_for_frequency('daily')
  end

  desc "Send weekly personalized recommendations to users"
  task send_weekly: :environment do
    send_recommendations_for_frequency('weekly')
  end

  desc "Send bi-weekly personalized recommendations to users"
  task send_biweekly: :environment do
    send_recommendations_for_frequency('biweekly')
  end

  desc "Send monthly personalized recommendations to users"
  task send_monthly: :environment do
    send_recommendations_for_frequency('monthly')
  end

  def send_recommendations_for_frequency(frequency)
    users = User.where(receive_recommendations: true, email_frequency: frequency)
    
    puts "Sending #{frequency} recommendations to #{users.count} users..."
    
    users.each do |user|
      # Skip if user has no bookmarks
      next if user.bookmarks.empty?
      
      begin
        RecommendationMailer.weekly_recommendations(user).deliver_now
        puts "✓ Sent recommendations to #{user.email}"
      rescue => e
        puts "✗ Failed to send to #{user.email}: #{e.message}"
      end
      
      # Add delay to avoid rate limiting
      sleep 1
    end
    
    puts "Done!"
  end
end
