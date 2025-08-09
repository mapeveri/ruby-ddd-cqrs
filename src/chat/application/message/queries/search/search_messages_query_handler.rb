module Chat
  ChatId = Chat::Domain::Message::ChatId
  MessageContent = Chat::Domain::Message::MessageContent
  SearchMessagesQueryResponse = Chat::Application::Message::Queries::Search::SearchMessagesQueryResponse

  class Application::Message::Queries::Search::SearchMessagesQueryHandler
    def initialize(search_messages_read_model:)
      @search_messages_read_model = search_messages_read_model
    end

    def call(query)
      chat_id = ChatId.of(query.chat_id)
      text = query.text

      messages_list = @search_messages_read_model.search(chat_id: chat_id, text: text)
      messages = self.map_messages(messages_list)

      SearchMessagesQueryResponse.new(
        messages: messages
      )
    end

    private
      def map_messages(messages_list)
        messages_list.map do |message|
          {
            id: message[:id],
            content: message[:content]
          }
        end
      end
  end
end
