class GetChatActivityQueryResponseMother
  def self.create(activity:)
    Analytics::Application::Queries::GetChatActivityQueryResponse.new(
      activity: activity
    )
  end
end
