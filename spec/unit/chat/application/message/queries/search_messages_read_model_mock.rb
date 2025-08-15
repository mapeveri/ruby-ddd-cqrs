class SearchMessagesReadModelMock < Chat::Application::Message::Queries::SearchMessagesReadModel
  def initialize
    @response = nil
  end

  def add(response)
    @response = response
  end

  def clear
    @response = nill
  end

  def search(chat_id:, text:)
    @response
  end
end
