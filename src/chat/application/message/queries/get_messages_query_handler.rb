module Chat
  ChatId = Chat::Domain::Message::ChatId

  class Application::Message::Queries::GetMessagesQueryHandler
    def initialize(get_messages_read_model:)
      @get_messages_read_model = get_messages_read_model
    end

    def call(query)
      chat_id = ChatId.of(query.chat_id)

      @get_messages_read_model.find_by_chat_id(chat_id: chat_id)
    end
  end
end
