class EmbeddingsService
  EMBEDDING_MODEL = "text-embedding-3-small"

  def initialize(api_key: ENV["OPENAI_API_KEY"])
    raise "OPENAI_API_KEY is not configured" if api_key.blank?

    require "openai"
    @client = OpenAI::Client.new(access_token: api_key)
  end

  def embed(text:)
    response = @client.embeddings.create(
      model: EMBEDDING_MODEL,
      input: text
    )

    response.dig("data", 0, "embedding") || []
  end
end
