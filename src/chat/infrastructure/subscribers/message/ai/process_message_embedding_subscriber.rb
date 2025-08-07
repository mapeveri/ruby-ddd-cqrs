module Chat
  MessageId = Chat::Domain::Message::MessageId
  GeminiEmbeddingClient = Shared::Infrastructure::Ai::Gemini::GeminiEmbeddingClient

  class Infrastructure::Subscribers::Message::Ai::ProcessMessageEmbeddingSubscriber
    def initialize(active_record_embedding_writer:)
      @active_record_embedding_writer = active_record_embedding_writer
    end

    def call(event)
      Rails.logger.info("[ProcessMessageEmbeddingSubscriber] -> Generating embedding")
      embedding = GeminiEmbeddingClient.embed_text(event.content)

      @active_record_embedding_writer.update_embedding(event.id, embedding)

      Chat::Infrastructure::Persistence::Redis::Projector::ChatMessagesProjector.store_message(
        chat_id: event.chat_id,
        message: {
          id: event.id,
          embedding: embedding
        }
      )
    end
  end
end
