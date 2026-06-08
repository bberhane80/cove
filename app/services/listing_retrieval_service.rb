class ListingRetrievalService
  DEFAULT_TOP_K = 5

  def retrieve(query, top_k: DEFAULT_TOP_K)
    return [] if query.blank?

    results = retrieve_with_embeddings(query, top_k: top_k)
    return results if results.any?

    keyword_fallback(query, top_k: top_k)
  rescue => e
    Rails.logger.error("ListingRetrievalService error: #{e.class}: #{e.message}")
    keyword_fallback(query, top_k: top_k)
  end

  private

  def retrieve_with_embeddings(query, top_k:)
    query_embedding = embeddings_service.embed(text: query)
    return [] if query_embedding.blank?

    ListingEmbedding.includes(:listing).where.not(embedding: nil).select do |record|
      record.embedding.is_a?(Array)
    end.map do |record|
      [record, cosine_similarity(query_embedding, record.embedding)]
    end.sort_by { |_, score| -score }
      .first(top_k)
      .map do |record, score|
        {
          listing: record.listing,
          score: score,
          snippet: build_snippet(record.listing)
        }
      end
  end

  def keyword_fallback(query, top_k:)
    terms = normalize_text(query).split.uniq
    Listing.all.map do |listing|
      score = terms.sum do |term|
        searchable_text(listing).scan(/\b#{Regexp.escape(term)}\b/).size
      end
      [listing, score]
    end.select { |_, score| score.positive? }
      .sort_by { |_, score| -score }
      .first(top_k)
      .map do |listing, score|
        {
          listing: listing,
          score: score,
          snippet: build_snippet(listing)
        }
      end
  end

  def searchable_text(listing)
    [listing.title, listing.description, listing.neighborhood, listing.details, listing.address, listing.city, listing.state].compact.join(' ').downcase
  end

  def normalize_text(text)
    text.to_s.downcase.gsub(/[^a-z0-9\s]/, ' ')
  end

  def cosine_similarity(vector_a, vector_b)
    dot = vector_a.zip(vector_b).sum { |a, b| a.to_f * b.to_f }
    magnitude_a = Math.sqrt(vector_a.sum { |a| a.to_f**2 })
    magnitude_b = Math.sqrt(vector_b.sum { |b| b.to_f**2 })
    return 0.0 if magnitude_a.zero? || magnitude_b.zero?
    dot / (magnitude_a * magnitude_b)
  end

  def build_snippet(listing)
    [listing.title, listing.city, listing.neighborhood, listing.description].compact.join(' – ').truncate(180)
  end

  def embeddings_service
    @embeddings_service ||= EmbeddingsService.new
  end
end
