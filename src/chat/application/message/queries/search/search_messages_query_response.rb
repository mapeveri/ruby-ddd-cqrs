class Chat::Application::Message::Queries::Search::SearchMessagesQueryResponse
  attr_reader :messages

  def initialize(messages:)
    @messages = messages
  end
end
