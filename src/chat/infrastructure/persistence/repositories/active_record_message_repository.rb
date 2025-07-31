class Chat::Infrastructure::Persistence::Repositories::ActiveRecordMessageRepository < Chat::Domain::Message::MessageRepository
  def find_by_id(id)
    record = MessageRecord.find_by(id: id.to_s)
    return nil unless record

    Chat::Domain::Message::Message.from_primitives(
      id: record.id,
      sender_id: record.sender_id,
      receiver_id: record.receiver_id,
      content: record.content,
      created_at: record.created_at
    )
  end

  def save(message)
    record = MessageRecord.find_or_initialize_by(id: message.id.to_s)
    record.sender_id = message.sender_id.to_s
    record.receiver_id = message.receiver_id.to_s
    record.content = message.content.to_s
    record.created_at = message.created_at
    record.save!
  end
end
