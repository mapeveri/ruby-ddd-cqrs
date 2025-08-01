class Chat::Domain::Message::MessageSent < Shared::Domain::DomainEvent
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

  def self.from(message)
    new(
      id: message.id.to_s,
      sender_id: message.sender_id.to_s,
      receiver_id: message.receiver_id.to_s,
      content: message.content.to_s,
      chat_id: message.chat_id.to_s,
      created_at: message.created_at
    )
  end

  def to_h
    {
      id: id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      chat_id: chat_id,
      created_at: created_at
    }
  end
end
