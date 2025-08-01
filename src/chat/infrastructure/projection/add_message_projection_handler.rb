class Chat::Infrastructure::Projection::AddMessageProjectionHandler
  def call(event)
    Rails.logger.info("[AddMessageProjectionHandler] -> #{event.to_h.to_json}")

    Chat::Infrastructure::Persistence::Redis::Projector::ChatMessagesProjector.store_message(
      chat_id: event.chat_id,
      message: {
        id: event.id,
        send_id: event.sender_id,
        receiver_id: event.receiver_id,
        chat_id: event.chat_id,
        content: event.content,
        created_at: Time.now
      }
    )
  end
end
