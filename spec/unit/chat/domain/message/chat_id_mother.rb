class ChatIdMother
  def self.create(value)
    Chat::Domain::Message::ChatId.of(value)
  end

  def self.random
    Chat::Domain::Message::ChatId.of(SecureRandom.uuid)
  end
end
