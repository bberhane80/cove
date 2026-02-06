class AddEmailPreferencesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :receive_recommendations, :boolean
  end
end
