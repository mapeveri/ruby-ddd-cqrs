module Chat
  SearchMessagesReadModel = Chat::Application::Message::Queries::SearchMessagesReadModel
  GeminiEmbeddingClient = Shared::Infrastructure::Ai::Gemini::GeminiEmbeddingClient

  class Infrastructure::Persistence::Redis::ReadModels::RedisSearchMessagesReadModel < SearchMessagesReadModel
    def initialize(redis_embedding:, gemini_llm_client:)
      @redis_embedding = redis_embedding
      @gemini_llm_client = gemini_llm_client
      super()
    end

    def search(chat_id:, text:)
      query_embedding = GeminiEmbeddingClient.embed_text(text)

      messages = @redis_embedding.search(chat_id: chat_id.to_s, query_embedding: query_embedding)

      contents = messages.map { |m| m.transform_keys(&:to_sym)[:content] }

      prompt = <<~PROMPT
        Answer the question using only the provided context.

        Context:
        #{contents.join("\n")}

        Question:
        #{text}
      PROMPT

      @gemini_llm_client.generate_text(prompt)
    end
  end
end
