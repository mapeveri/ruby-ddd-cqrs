class SearchMessagesReadModelMock < Chat::Application::Message::Queries::Search::SearchMessagesReadModel
  def initialize
    @messages = []
  end

  def add(message)
    @messages << message
  end

  def clear
    @messages.clear
  end

  def search(chat_id:, text:)
    @messages
  end
end
