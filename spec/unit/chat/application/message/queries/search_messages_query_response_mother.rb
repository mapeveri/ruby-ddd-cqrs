class SearchMessagesQueryResponseMother
  def self.create(messages:)
    Chat::Application::Message::Queries::SearchMessagesQueryResponse.new(
      messages: messages
    )
  end
end
