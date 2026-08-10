class Analytics::Application::Queries::GetChatActivityQuery
  attr_reader :chat_id

  def initialize(chat_id:)
    @chat_id = chat_id
  end
end
