class GetMessagesReadModelMock < Chat::Application::Message::Queries::GetMessagesReadModel
  def initialize
    @messages = []
  end

  def add(message)
    @messages << message
  end

  def clear
    @messages.clear
  end

  def find_by_chat_id(chat_id)
    @messages
  end
end
