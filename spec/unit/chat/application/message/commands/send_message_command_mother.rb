class SendMessageCommandMother
  def self.random
    Chat::Application::Message::Commands::SendMessageCommand.new(
      id: SecureRandom.uuid,
      sender_id: SecureRandom.uuid,
      receiver_id: SecureRandom.uuid,
      content: Faker::Lorem.sentence
    )
  end
end
