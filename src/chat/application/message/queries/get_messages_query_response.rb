class Chat::Application::Message::Queries::GetMessagesQueryResponse
  attr_reader :messages

  def initialize(messages:)
    @messages = messages
  end
end
