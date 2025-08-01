class Chat::Application::Message::Queries::GetMessagesReadModel
  attr_reader :chat_id

  def find_by_chat_id(chat_id:)
    raise "find_by_chat_id method not implemented"
  end
end
