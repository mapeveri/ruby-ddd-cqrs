class MessageMother
  def self.create(
    id: MessageIdMother.random,
    sender_id: UserIdMother.random,
    receiver_id: UserIdMother.random,
    content: MessageContentMother.random,
    created_at: Time.now
  )
    Chat::Domain::Message::Message.new(
      id: id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      created_at: created_at
    )
  end

  def self.random
    create
  end

  def self.with_id(id)
    create(id: id)
  end
end
