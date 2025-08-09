class Chat::Application::Message::Queries::Search::SearchMessagesQuery
  attr_reader :chat_id, :text

  def initialize(chat_id:, text:)
    @chat_id = chat_id
    @text = text
  end
end
