class Chat::Infrastructure::Subscribers::Projection::AddMessageProjectionSubscriber
  def call(event)
    Rails.logger.info("[AddMessageProjectionSubscriber] -> #{event.to_h.to_json}")

    Chat::Infrastructure::Persistence::Redis::Projector::ChatMessagesProjector.store_message(
      chat_id: event.chat_id,
      message: event.to_h
    )
  end
end
