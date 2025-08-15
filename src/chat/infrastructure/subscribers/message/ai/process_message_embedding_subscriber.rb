module Chat
  MessageId = Chat::Domain::Message::MessageId
  GeminiEmbeddingClient = Shared::Infrastructure::Ai::Gemini::GeminiEmbeddingClient

  class Infrastructure::Subscribers::Message::Ai::ProcessMessageEmbeddingSubscriber
    def initialize(active_record_embedding_writer:, gemini_embedding_client:, redis_embedding:)
      @active_record_embedding_writer = active_record_embedding_writer
      @gemini_embedding_client = gemini_embedding_client
      @redis_embedding = redis_embedding
    end

    def call(event)
      Rails.logger.info("[ProcessMessageEmbeddingSubscriber] -> Generating embedding")
      embedding = @gemini_embedding_client.embed_text(event.content)

      Rails.logger.info("[ProcessMessageEmbeddingSubscriber] -> Storing in active record")
      @active_record_embedding_writer.update_embedding(event.id, embedding)

      Rails.logger.info("[ProcessMessageEmbeddingSubscriber] -> Generating in redis")
      @redis_embedding.store(id: event.id, chat_id: event.chat_id, content: event.content, embedding: embedding)
    end
  end
end
