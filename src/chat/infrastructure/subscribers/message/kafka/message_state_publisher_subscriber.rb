module Chat
  class Infrastructure::Subscribers::Message::Kafka::MessageStatePublisherSubscriber
    def initialize(message_state_publisher:)
      @message_state_publisher = message_state_publisher
    end

    def call(event)
      record = MessageRecord.find_by(id: event.id.to_s)
      return unless record

      @message_state_publisher.publish_state(record)
    end
  end
end
