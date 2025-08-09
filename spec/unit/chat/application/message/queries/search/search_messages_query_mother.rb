class SearchMessagesQueryMother
  def self.create(
    chat_id: SecureRandom.uuid,
    text: Faker::Lorem.sentence
  )
    Chat::Application::Message::Queries::Search::SearchMessagesQuery.new(
      chat_id: chat_id,
      text: text
    )
  end

  def self.random
    create
  end

  def self.with_invalid_chat_id
    create(chat_id: '')
  end
end
