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

  class << self
    def from(message)
      new(
        id: message.id.to_s,
        sender_id: message.sender_id.to_s,
        receiver_id: message.receiver_id.to_s,
        content: message.content.to_s,
        chat_id: message.chat_id.to_s,
        created_at: message.created_at
      )
    end

    def from_h(hash)
      new(
        id: hash["id"],
        sender_id: hash["sender_id"],
        receiver_id: hash["receiver_id"],
        content: hash["content"],
        chat_id: hash["chat_id"],
        created_at: hash["created_at"]
      )
    end

    def event_name
      "chat.message.sent"
    end
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
