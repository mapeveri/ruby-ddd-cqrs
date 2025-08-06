class GetMessagesQueryResponseMother
  def self.create(messages:)
    Chat::Application::Message::Queries::GetMessagesQueryResponse.new(
      messages: messages
    )
  end
end
