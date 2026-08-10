class Analytics::Application::Queries::GetUserEngagementQueryResponse
  attr_reader :engagement

  def initialize(engagement:)
    @engagement = engagement
  end
end
