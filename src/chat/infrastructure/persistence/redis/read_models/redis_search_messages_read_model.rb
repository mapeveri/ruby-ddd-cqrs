module Chat
  SearchMessagesReadModel = Chat::Application::Message::Queries::SearchMessagesReadModel
  GeminiEmbeddingClient = Shared::Infrastructure::Ai::Gemini::GeminiEmbeddingClient

  class Infrastructure::Persistence::Redis::ReadModels::RedisSearchMessagesReadModel < SearchMessagesReadModel
    def initialize(redis_embedding:)
      @redis_embedding = redis_embedding
      super()
    end
    def search(chat_id:, text:)
      query_embedding = GeminiEmbeddingClient.embed_text(text)

      messages = @redis_embedding.search(chat_id: chat_id.to_s, query_embedding: query_embedding)

      messages.map do |message|
        message.transform_keys(&:to_sym)
      end
    end
  end
end
