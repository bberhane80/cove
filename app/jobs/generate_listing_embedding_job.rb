class GenerateListingEmbeddingJob < ApplicationJob
  queue_as :default

  def perform(listing_id)
    listing = Listing.find_by(id: listing_id)
    return unless listing

    ListingEmbeddingBuilder.new.build_for(listing)
  rescue => e
    Rails.logger.error("Failed to generate embedding for Listing #{listing_id}: #{e.class}: #{e.message}")
  end
end
