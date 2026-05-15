namespace :embeddings do
  desc "Build embeddings for all listings"
  task build_listings: :environment do
    Rails.logger.info("Starting embedding generation for listings...")
    ListingEmbeddingBuilder.new.build_all!
    Rails.logger.info("Listing embedding generation complete.")
  rescue => e
    Rails.logger.error("Failed to build listing embeddings: #{e.class}: #{e.message}")
    raise
  end
end
