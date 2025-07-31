module Chat::Application::Message::Commands
  UserId = Chat::Domain::User::UserId
  MessageId = Chat::Domain::Message::MessageId
  Message = Chat::Domain::Message::Message

  class SendMessageCommandHandler
    def initialize(message_repository:)
      @message_repository = message_repository
    end

    def call(command)
      id = MessageId.of(command.id)
      sender_id = UserId.of(command.sender_id)
      receiver_id = UserId.of(command.receiver_id)
      content = command.content

      message = Message.create(id: id, sender_id: sender_id, receiver_id: receiver_id, content: content)

      @message_repository.save(message)
    end
  end
end
