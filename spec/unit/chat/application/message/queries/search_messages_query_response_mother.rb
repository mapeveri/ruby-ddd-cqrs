class SearchMessagesQueryResponseMother
  def self.create(response:)
    Chat::Application::Message::Queries::SearchMessagesQueryResponse.new(
      response: response
    )
  end
end
