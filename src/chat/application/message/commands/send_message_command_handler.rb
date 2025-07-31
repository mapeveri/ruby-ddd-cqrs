module Chat::Application::Message::Commands
  UserId = Chat::Domain::User::UserId
  MessageId = Chat::Domain::Message::MessageId
  Message = Chat::Domain::Message::Message
  MessageContent = Chat::Domain::Message::MessageContent

  class SendMessageCommandHandler
    def initialize(message_repository:, event_bus:)
      @message_repository = message_repository
      @event_bus = event_bus
    end

    def call(command)
      id = MessageId.of(command.id)
      sender_id = UserId.of(command.sender_id)
      receiver_id = UserId.of(command.receiver_id)
      content = MessageContent.of(command.content)

      message = Message.send(id: id, sender_id: sender_id, receiver_id: receiver_id, content: content)

      @message_repository.save(message)
      @event_bus.publish(message.pull_domain_events)
    end
  end
end
