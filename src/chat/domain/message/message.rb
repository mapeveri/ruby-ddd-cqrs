class Chat::Domain::Message::Message
  attr_reader :id, :sender_id, :receiver_id, :content, :created_at

  def initialize(id:, sender_id:, receiver_id:, content:, created_at:)
    @id = id
    @sender_id = sender_id
    @receiver_id = receiver_id
    @content = content
    @created_at = created_at
  end

  def self.create(id:, sender_id:, receiver_id:, content:)
    new(
      id: id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      created_at: Time.now
    )
  end
end
