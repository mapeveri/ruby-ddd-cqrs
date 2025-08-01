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
