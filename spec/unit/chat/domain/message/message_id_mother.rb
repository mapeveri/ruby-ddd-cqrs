class MessageIdMother
  def self.create(value)
    Chat::Domain::Message::MessageId.of(value)
  end

  def self.random
    Chat::Domain::Message::MessageId.of(SecureRandom.uuid)
  end
end
