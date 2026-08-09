class Analytics::Application::Queries::GetChatActivityQueryResponse
  attr_reader :activity

  def initialize(activity:)
    @activity = activity
  end
end
