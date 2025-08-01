class Chat::Domain::Message::Message < Shared::Domain::AggregateRoot
  attr_reader :id, :sender_id, :receiver_id, :content, :chat_id, :created_at

  def initialize(id:, sender_id:, receiver_id:, content:, chat_id:, created_at:)
    super()

    @id = id
    @sender_id = sender_id
    @receiver_id = receiver_id
    @content = content
    @chat_id = chat_id
    @created_at = created_at
  end

  def self.send(id:, sender_id:, receiver_id:, content:, chat_id:)
    created_at = Time.now
    message = new(
      id: id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      chat_id: chat_id,
      created_at: created_at
    )

    message.record(Chat::Domain::Message::MessageSent.from(message))

    message
  end

  def to_h
    {
      id: id.to_s,
      sender_id: sender_id.to_s,
      receiver_id: receiver_id.to_s,
      content: content.to_s,
      chat_id: chat_id.to_s,
      created_at: created_at.to_s
    }
  end

  def self.from_primitives(data)
    new(
      id: Chat::Domain::Message::MessageId.from_primitives(data[:id]),
      sender_id: Chat::Domain::User::UserId.from_primitives(data[:sender_id]),
      receiver_id: Chat::Domain::User::UserId.from_primitives(data[:receiver_id]),
      content: Chat::Domain::Message::MessageContent.from_primitives(data[:content]),
      chat_id: Chat::Domain::Message::ChatId.from_primitives(data[:chat_id]),
      created_at: data[:created_at]
    )
  end
end
