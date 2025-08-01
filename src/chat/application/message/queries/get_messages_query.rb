class Chat::Application::Message::Queries::GetMessagesQuery
  attr_reader :chat_id

  def initialize(chat_id:)
    @chat_id = chat_id
  end
end
