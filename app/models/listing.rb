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
class Listing < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user
  has_one :listing_embedding, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 2000 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :bedrooms, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :bathrooms, numericality: { greater_than: 0 }
  validates :city, :state, presence: true

  PROPERTY_TYPES = [ "House", "Apartment", "Condo", "Townhouse", "Land" ]

  scope :recent, -> { order(created_at: :desc) }
  scope :by_city, ->(city) { where(city: city) if city.present? }
  scope :by_price_range, ->(min, max) { where(price: min..max) if min.present? && max.present? }

  def embedding_text
    [title, description, neighborhood, details, address, city, state].compact.join(' ')
  end
end
