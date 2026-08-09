module Analytics
  GetUserEngagementReadModel = Analytics::Application::Queries::GetUserEngagementReadModel

  class Infrastructure::Persistence::Redis::ReadModels::RedisUserEngagementReadModel < GetUserEngagementReadModel
    def initialize(user_engagement_projector:)
      @user_engagement_projector = user_engagement_projector
      super()
    end

    def find_by_user_id(user_id:)
      @user_engagement_projector.fetch_user_engagement(user_id: user_id.to_s)
    end
  end
end
