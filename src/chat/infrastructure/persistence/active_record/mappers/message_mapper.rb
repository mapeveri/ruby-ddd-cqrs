class Chat::Infrastructure::Persistence::ActiveRecord::Mappers::MessageMapper
  class << self
    def to_entity(record)
      Chat::Domain::Message::Message.from_primitives(
        id: record.id,
        sender_id: record.sender_id,
        receiver_id: record.receiver_id,
        content: record.content,
        chat_id: record.chat_id,
        created_at: record.created_at
      )
    end

    def to_record(entity)
      {
        sender_id: entity.sender_id.to_s,
        receiver_id: entity.receiver_id.to_s,
        content: entity.content.to_s,
        chat_id: entity.chat_id.to_s,
        created_at: entity.created_at
      }
    end
  end
end
