class MessageContentMother
  def self.create(value)
    Chat::Domain::Message::MessageContent.of(value)
  end

  def self.random
    Chat::Domain::Message::MessageContent.of(Faker::Lorem.sentence)
  end
end
