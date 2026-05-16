 class AddEmailPreferencesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :receive_recommendations, :boolean, default: true
  end
 end
