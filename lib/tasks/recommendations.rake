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

  desc "Send a recommendation email to a specific user by id or email"
  task :send, [:user_identifier] => :environment do |_task, args|
    identifier = args[:user_identifier]
    unless identifier.present?
      puts "Usage: bundle exec rake recommendations:send[user_id|user_email]"
      exit 1
    end

    user = User.find_by(id: identifier) || User.find_by(email: identifier)
    unless user
      puts "User not found for '#{identifier}'"
      exit 1
    end

    if User.send_recommendation_email!(user)
      puts "Recommendation email triggered for #{user.email}"
    else
      puts "No recommendation email sent for #{user.email}"
    end
  end

  desc "Send recommendation emails now for all due users"
  task send_due: :environment do
    count = User.send_due_recommendation_emails!
    puts "Recommendation emails delivered for #{count} user(s)."
  end
end
