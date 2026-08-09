module Analytics
  GetChatActivityReadModel = Analytics::Application::Queries::GetChatActivityReadModel

  class Infrastructure::Persistence::Redis::ReadModels::RedisChatActivityReadModel < GetChatActivityReadModel
    def initialize(chat_activity_projector:)
      @chat_activity_projector = chat_activity_projector
      super()
    end

    def find_by_chat_id(chat_id:)
      @chat_activity_projector.fetch_chat_activity(chat_id: chat_id.to_s)
    end
  end
end
