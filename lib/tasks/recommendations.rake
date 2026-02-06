namespace :recommendations do
  desc "Send weekly personalized recommendations to users"
  task send_weekly: :environment do
    users = User.where(receive_recommendations: true)
    
    puts "Sending recommendations to #{users.count} users..."
    
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
