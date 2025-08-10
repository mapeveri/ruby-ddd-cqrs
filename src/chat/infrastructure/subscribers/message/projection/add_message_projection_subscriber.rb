class Chat::Infrastructure::Subscribers::Message::Projection::AddMessageProjectionSubscriber
  def initialize(redis_chat_messages_projector:)
    @redis_chat_messages_projector = redis_chat_messages_projector
  end

  def call(event)
    Rails.logger.info("[AddMessageProjectionSubscriber] -> #{event.to_h.to_json}")

    @redis_chat_messages_projector.store_message(
      chat_id: event.chat_id,
      message: event.to_h
    )
  end
end
