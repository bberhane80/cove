# == Schema Information
#
# Table name: listings
#
#  id           :bigint           not null, primary key
#  address      :string
#  bathrooms    :decimal(3, 1)
#  bedrooms     :integer
#  city         :string
#  description  :text
#  details      :text
#  image_url    :string
#  neighborhood :text
#  price        :decimal(10, 2)
#  square_feet  :integer
#  state        :string
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
require 'rails_helper'

describe Listing, type: :model do
  it 'is valid with valid attributes' do
    listing = Listing.new(title: 'Test', description: 'Test desc', location: 'Test City', price: 100)
    expect(listing).to be_valid
  end
end
