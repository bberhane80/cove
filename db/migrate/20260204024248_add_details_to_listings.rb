class AddDetailsToListings < ActiveRecord::Migration[7.0]
  def change
    # Only add columns that don't exist yet
    add_column :listings, :title, :string unless column_exists?(:listings, :title)
    add_column :listings, :description, :text unless column_exists?(:listings, :description)
    # Skip address since it already exists
    add_column :listings, :price, :decimal, precision: 10, scale: 2 unless column_exists?(:listings, :price)
    add_column :listings, :bedrooms, :integer unless column_exists?(:listings, :bedrooms)
    add_column :listings, :bathrooms, :decimal, precision: 3, scale: 1 unless column_exists?(:listings, :bathrooms)
    add_column :listings, :square_feet, :integer unless column_exists?(:listings, :square_feet)
    add_column :listings, :image_url, :string unless column_exists?(:listings, :image_url)
  end
end
