module Chat
  ChatId = Chat::Domain::Message::ChatId
  GetMessagesQueryResponse = Chat::Application::Message::Queries::GetMessagesQueryResponse

  class Application::Message::Queries::GetMessagesQueryHandler
    def initialize(get_messages_read_model:)
      @get_messages_read_model = get_messages_read_model
    end

    def call(query)
      chat_id = ChatId.of(query.chat_id)
      messages_list = @get_messages_read_model.find_by_chat_id(chat_id: chat_id)

      messages = self.map_messages(messages_list)

      GetMessagesQueryResponse.new(
        messages: messages
      )
    end

    private
      def map_messages(messages_list)
        messages_list.map do |message|
          {
            id: message[:id],
            sender_id: message[:sender_id],
            receiver_id: message[:receiver_id],
            content: message[:content],
            chat_id: message[:chat_id],
            created_at: message[:created_at]
          }
        end
      end
  end
end
