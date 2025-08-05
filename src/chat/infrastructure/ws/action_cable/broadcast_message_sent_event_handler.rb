class Chat::Infrastructure::Ws::ActionCable::BroadcastMessageSentEventHandler
  def call(event)
    ActionCable.server.broadcast(
      "chat_#{event.chat_id}",
      {
        id: event.id,
        sender_id: event.sender_id,
        receiver_id: event.receiver_id,
        content: event.content,
        chat_id: event.chat_id
      }.to_json
    )
  end
end
