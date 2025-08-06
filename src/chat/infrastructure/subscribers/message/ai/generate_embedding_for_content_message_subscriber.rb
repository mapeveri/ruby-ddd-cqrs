module Chat
  MessageId = Chat::Domain::Message::MessageId
  GeminiEmbeddingClient = Shared::Infrastructure::Ai::Gemini::GeminiEmbeddingClient

  class Infrastructure::Subscribers::Message::Ai::GenerateEmbeddingForContentMessageSubscriber
    def initialize(active_record_embedding_writer:)
      @active_record_embedding_writer = active_record_embedding_writer
    end

    def call(event)
      Rails.logger.info("[GenerateEmbeddingForContentMessageSubscriber] -> Generating embedding")
      embedding = GeminiEmbeddingClient.embed_text(event.content)
      @active_record_embedding_writer.update_embedding(event.id, embedding)
    end
  end
end
