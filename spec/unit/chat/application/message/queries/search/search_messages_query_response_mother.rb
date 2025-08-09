class SearchMessagesQueryResponseMother
  def self.create(messages:)
    Chat::Application::Message::Queries::Search::SearchMessagesQueryResponse.new(
      messages: messages
    )
  end
end
