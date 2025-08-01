class Chat::Infrastructure::Projection::AddMessageProjectionHandler
  def call(event)
    Rails.logger.info("[AddMessageProjectionHandler] -> #{event.to_h.to_json}")

    Chat::Infrastructure::Persistence::Redis::Projector::ChatMessagesProjector.store_message(
      chat_id: event.chat_id,
      message: event.to_h
    )
  end
end
