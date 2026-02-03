# == Schema Information
#
# Table name: listings
#
#  id           :bigint           not null, primary key
#  address      :string
#  city         :string
#  details      :text
#  neighborhood :text
#  state        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
class Listing < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  validates :title, :price, :bedrooms, :bathrooms, :address, :city, :state, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :bedrooms, :bathrooms, numericality: { greater_than_or_equal_to: 0 }

  PROPERTY_TYPES = [ "House", "Apartment", "Condo", "Townhouse", "Land" ]

  scope :recent, -> { order(created_at: :desc) }
  scope :by_city, ->(city) { where(city: city) if city.present? }
  scope :by_price_range, ->(min, max) { where(price: min..max) if min.present? && max.present? }
end
