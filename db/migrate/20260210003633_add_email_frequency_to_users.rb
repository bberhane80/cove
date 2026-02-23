class AddEmailFrequencyToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :email_frequency, :string
  end
end
