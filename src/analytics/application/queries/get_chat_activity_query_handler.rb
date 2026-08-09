module Analytics
  ChatId = Chat::Domain::Message::ChatId
  GetChatActivityQueryResponse = Analytics::Application::Queries::GetChatActivityQueryResponse

  class Application::Queries::GetChatActivityQueryHandler
    def initialize(read_model:)
      @read_model = read_model
    end

    def call(query)
      chat_id = ChatId.of(query.chat_id)
      activity = @read_model.find_by_chat_id(chat_id: chat_id)

      GetChatActivityQueryResponse.new(
        activity: activity
      )
    end
  end
end
