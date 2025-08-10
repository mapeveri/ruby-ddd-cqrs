class Chat::Infrastructure::Persistence::Redis::Projector::ChatMessagesProjector < Shared::Infrastructure::Persistence::Redis::Projector::RedisProjector
  PREFIX = "chat:messages"

  def store_message(chat_id:, message:)
    key = "#{PREFIX}:#{chat_id}"
    store(key: key, value: message, index_field: 'id')
  end

  def fetch_messages(chat_id:, limit: 50)
    key = "#{PREFIX}:#{chat_id}"
    fetch(key: key, limit: limit)
  end
end
