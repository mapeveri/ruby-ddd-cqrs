module Chat
  MessageId = Chat::Domain::Message::MessageId
  GeminiEmbeddingClient = Shared::Infrastructure::Ai::Gemini::GeminiEmbeddingClient
  RedisEmbedding = Chat::Infrastructure::Persistence::Redis::Services::RedisEmbedding

  class Infrastructure::Subscribers::Message::Ai::ProcessMessageEmbeddingSubscriber
    def initialize(active_record_embedding_writer:)
      @active_record_embedding_writer = active_record_embedding_writer
    end

    def call(event)
      Rails.logger.info("[ProcessMessageEmbeddingSubscriber] -> Generating embedding")
      embedding = GeminiEmbeddingClient.embed_text(event.content)

      Rails.logger.info("[ProcessMessageEmbeddingSubscriber] -> Storing in active record")
      @active_record_embedding_writer.update_embedding(event.id, embedding)

      Rails.logger.info("[ProcessMessageEmbeddingSubscriber] -> Generating in redis")
      RedisEmbedding.store(id: event.id, chat_id: event.chat_id, content: event.content, embedding: embedding)
    end
  end
end
