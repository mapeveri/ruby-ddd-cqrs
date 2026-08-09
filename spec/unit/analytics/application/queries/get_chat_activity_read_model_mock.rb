class GetChatActivityReadModelMock < Analytics::Application::Queries::GetChatActivityReadModel
  def initialize
    @activities = {}
  end

  def add(chat_id:, activity:)
    @activities[chat_id.to_s] = activity
  end

  def clear
    @activities.clear
  end

  def find_by_chat_id(chat_id:)
    @activities[chat_id.to_s]
  end
end
