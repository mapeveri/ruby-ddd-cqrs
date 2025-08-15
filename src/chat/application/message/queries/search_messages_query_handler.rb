module Chat
  ChatId = Chat::Domain::Message::ChatId
  MessageContent = Chat::Domain::Message::MessageContent
  SearchMessagesQueryResponse = Chat::Application::Message::Queries::SearchMessagesQueryResponse

  class Application::Message::Queries::SearchMessagesQueryHandler
    def initialize(search_messages_read_model:)
      @search_messages_read_model = search_messages_read_model
    end

    def call(query)
      chat_id = ChatId.of(query.chat_id)
      text = query.text

      response = @search_messages_read_model.search(chat_id: chat_id, text: text)

      SearchMessagesQueryResponse.new(
        response: response
      )
    end
  end
end
