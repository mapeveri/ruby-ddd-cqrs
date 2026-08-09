class GetChatActivityQueryMother
  def self.create(chat_id: SecureRandom.uuid)
    Analytics::Application::Queries::GetChatActivityQuery.new(
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
