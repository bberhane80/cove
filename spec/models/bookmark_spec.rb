# == Schema Information
#
# Table name: bookmarks
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  listing_id :integer
#  user_id    :integer
#
require 'rails_helper'

describe Bookmark, type: :model do
  it 'is valid with valid attributes' do
    user = User.create(email: 'test@example.com', password: 'password123')
    listing = Listing.create(title: 'Test', description: 'Test desc', city: 'Boston', price: 1000)
    bookmark = Bookmark.new(user: user, listing: listing)
    expect(bookmark).to be_valid
  end
end
