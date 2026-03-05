class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings do |t|
      t.integer :user_id
      t.string :address
      t.text :details
      t.text :neighborhood
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
