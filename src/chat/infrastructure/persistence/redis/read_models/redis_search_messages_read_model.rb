module Chat
  SearchMessagesReadModel = Chat::Application::Message::Queries::SearchMessagesReadModel
  GeminiEmbeddingClient = Shared::Infrastructure::Ai::Gemini::GeminiEmbeddingClient
  RedisEmbedding = Chat::Infrastructure::Persistence::Redis::Services::RedisEmbedding

  class Infrastructure::Persistence::Redis::ReadModels::RedisSearchMessagesReadModel < SearchMessagesReadModel
    def search(chat_id:, text:)
      query_embedding = GeminiEmbeddingClient.embed_text(text)

      messages = RedisEmbedding.search(chat_id: chat_id.to_s, query_embedding: query_embedding)

      messages.map do |message|
        message.transform_keys(&:to_sym)
      end
    end
  end
end
