module Chat
  MessageMapper = Chat::Infrastructure::Persistence::ActiveRecord::Mappers::MessageMapper
  MessageRepository = Chat::Domain::Message::MessageRepository

  class Infrastructure::Persistence::ActiveRecord::Repositories::ActiveRecordMessageRepository < MessageRepository
    def find_by_id(id)
      record = MessageRecord.find_by(id: id.to_s)
      return nil unless record

      MessageMapper.to_entity(record)
    end

    def save(message, persistence_options = {})
      record = MessageRecord.find_or_initialize_by(id: message.id.to_s)
      record.assign_attributes(MessageMapper.to_record(message))

      if persistence_options.key?(:embedding)
        record.embedding = persistence_options[:embedding]
      end

      record.save!
    end
  end
end
