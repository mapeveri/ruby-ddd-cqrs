class GetUserEngagementReadModelMock < Analytics::Application::Queries::GetUserEngagementReadModel
  def initialize
    @engagements = {}
  end

  def add(user_id:, engagement:)
    @engagements[user_id.to_s] = engagement
  end

  def clear
    @engagements.clear
  end

  def find_by_user_id(user_id:)
    @engagements[user_id.to_s]
  end
end
