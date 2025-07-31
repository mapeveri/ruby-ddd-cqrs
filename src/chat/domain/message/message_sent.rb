class Chat::Domain::Message::MessageSent < Shared::Domain::DomainEvent
  attr_reader :id, :sender_id, :receiver_id, :content

  def initialize(id:, sender_id:, receiver_id:, content:)
    super()
    @id = id
    @sender_id = sender_id
    @receiver_id = receiver_id
    @content = content
  end
end
