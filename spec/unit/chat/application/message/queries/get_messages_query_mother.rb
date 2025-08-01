class GetMessagesQueryMother
  def self.create(
    chat_id: SecureRandom.uuid
  )
    Chat::Application::Message::Queries::GetMessagesQuery.new(
      chat_id: chat_id
    )
  end

  def self.random
    create
  end

  def self.with_invalid_chat_id
    create(chat_id: '')
  end
end
