class Chat::Domain::Message::Message < Shared::Domain::AggregateRoot
  attr_reader :id, :sender_id, :receiver_id, :content, :created_at

  def initialize(id:, sender_id:, receiver_id:, content:, created_at:)
    super()

    @id = id
    @sender_id = sender_id
    @receiver_id = receiver_id
    @content = content
    @created_at = created_at
  end

  def self.send(id:, sender_id:, receiver_id:, content:)
    message = new(
      id: id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      created_at: Time.now
    )

    message.record(
      Chat::Domain::Message::MessageSent.new(
        id: id,
        sender_id: sender_id,
        receiver_id: receiver_id,
        content: content
      )
    )

    message
  end
end
