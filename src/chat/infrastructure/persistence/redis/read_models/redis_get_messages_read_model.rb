module Chat
  GetMessagesReadModel = Chat::Application::Message::Queries::GetMessagesReadModel

  class Infrastructure::Persistence::Redis::ReadModels::RedisGetMessagesReadModel < GetMessagesReadModel
    def find_by_chat_id(chat_id:)
      Chat::Infrastructure::Persistence::Redis::Projector::ChatMessagesProjector.fetch_messages(
        chat_id: chat_id.to_s,
        limit: 1000
      )
    end
  end
end
