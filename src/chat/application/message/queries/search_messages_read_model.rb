class Chat::Application::Message::Queries::SearchMessagesReadModel
  attr_reader :chat_id, :text

  def search(chat_id:, text:)
    raise "search method not implemented"
  end
end
