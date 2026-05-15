# == Schema Information
#
# Table name: listing_embeddings
#
#  id         :bigint           not null, primary key
#  listing_id :bigint           not null
#  embedding  :jsonb            not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_listing_embeddings_on_listing_id  (listing_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (listing_id => listings.id)
#
class ListingEmbedding < ApplicationRecord
  belongs_to :listing

  validates :listing, presence: true
  validates :embedding, presence: true
  validates :content, presence: true

  def vector
    embedding || []
  end
end
