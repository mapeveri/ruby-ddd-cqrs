class Chat::Application::Message::Queries::SearchMessagesQueryResponse
  attr_reader :response

  def initialize(response:)
    @response = response
  end
end
