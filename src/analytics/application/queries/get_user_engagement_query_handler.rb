module Analytics
  UserId = Chat::Domain::User::UserId
  GetUserEngagementQueryResponse = Analytics::Application::Queries::GetUserEngagementQueryResponse

  class Application::Queries::GetUserEngagementQueryHandler
    def initialize(read_model:)
      @read_model = read_model
    end

    def call(query)
      user_id = UserId.of(query.user_id)
      engagement = @read_model.find_by_user_id(user_id: user_id)

      GetUserEngagementQueryResponse.new(
        engagement: engagement
      )
    end
  end
end
