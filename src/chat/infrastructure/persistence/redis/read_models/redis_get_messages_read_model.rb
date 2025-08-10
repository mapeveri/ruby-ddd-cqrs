module Chat
  GetMessagesReadModel = Chat::Application::Message::Queries::GetMessagesReadModel

  class Infrastructure::Persistence::Redis::ReadModels::RedisGetMessagesReadModel < GetMessagesReadModel
    def initialize(chat_messages_projector:)
      @chat_messages_projector = chat_messages_projector
      super()
    end

    def find_by_chat_id(chat_id:)
      messages = @chat_messages_projector.fetch_messages(
        chat_id: chat_id.to_s,
        limit: 1000
      )

      messages.map do |message|
        message.transform_keys(&:to_sym)
      end
    end
  end
end
