class ListingEmbeddingBuilder
  def initialize
    @embeddings_service = EmbeddingsService.new
  end

  def build_for(listing)
    embedding = @embeddings_service.embed(text: listing.embedding_text)
    raise "Embedding generation failed for listing #{listing.id}" if embedding.blank?

    record = ListingEmbedding.find_or_initialize_by(listing: listing)
    record.update!(embedding: embedding, content: listing.embedding_text)
    record
  end

  def build_all!
    Listing.find_each do |listing|
      build_for(listing)
    end
  end
end
