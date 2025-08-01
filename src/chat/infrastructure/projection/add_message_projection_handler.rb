class Chat::Infrastructure::Projection::AddMessageProjectionHandler
  def self.call(event)
    Rails.logger.info("[AddMessageProjectionHandler] -> #{event.to_h.to_json}")

    Chat::Infrastructure::Persistence::Redis::Projector::ChatMessagesProjector.store_message(
      chat_id: event.chat_id,
      message: {
        id: event.id,
        content: event.content,
        created_at: Time.now
      }
    )
  end
end
