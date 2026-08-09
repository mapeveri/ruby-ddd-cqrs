class GetUserEngagementQueryResponseMother
  def self.create(engagement:)
    Analytics::Application::Queries::GetUserEngagementQueryResponse.new(
      engagement: engagement
    )
  end
end
