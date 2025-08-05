module Chat
  MessageId = Chat::Domain::Message::MessageId
  GeminiEmbeddingClient = Shared::Infrastructure::Ai::Gemini::GeminiEmbeddingClient

  class Infrastructure::Subscribers::Message::Ai::Gemini::GenerateEmbeddingForContentMessageSubscriber
    def initialize(message_repository:)
      @message_repository = message_repository
    end

    def call(event)
      Rails.logger.info("[GenerateEmbeddingForContentMessageSubscriber] -> Generating embedding")
      embedding = GeminiEmbeddingClient.embed_text(event.content)
      message = @message_repository.find_by_id(MessageId.of(event.id))

      @message_repository.save(message, embedding: embedding)
    end
  end
end
