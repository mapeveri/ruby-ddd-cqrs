class Analytics::Application::Queries::GetUserEngagementQuery
  attr_reader :user_id

  def initialize(user_id:)
    @user_id = user_id
  end
end
