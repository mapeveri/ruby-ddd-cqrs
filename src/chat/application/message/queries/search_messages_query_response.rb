class Chat::Application::Message::Queries::SearchMessagesQueryResponse
  attr_reader :messages

  def initialize(messages:)
    @messages = messages
  end
end
