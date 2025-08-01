class SendMessageCommandMother
  def self.create(
    id: SecureRandom.uuid,
    sender_id: SecureRandom.uuid,
    receiver_id: SecureRandom.uuid,
    content: Faker::Lorem.sentence,
    chat_id: SecureRandom.uuid
  )
    Chat::Application::Message::Commands::SendMessageCommand.new(
      id: id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      chat_id: chat_id
    )
  end

  def self.random
    create
  end

  def self.with_id(id)
    create(id: id)
  end

  def self.with_invalid_id
    create(id: '')
  end

  def self.with_invalid_sender_id
    create(sender_id: '')
  end

  def self.with_invalid_receiver_id
    create(receiver_id: '')
  end

  def self.with_invalid_chat_id
    create(chat_id: '')
  end

  def self.with_invalid_content
    create(content: '')
  end
end
