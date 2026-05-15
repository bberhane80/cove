class AddLastRecommendationSentAtToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :last_recommendation_sent_at, :datetime
    add_index :users, :last_recommendation_sent_at
  end
end
