class Chat::Infrastructure::Persistence::Repositories::ActiveRecordMessageRepository < Chat::Domain::Message::MessageRepository
  def initialize
    @messages = []
  end

  def save(message)
    @messages << message
  end
end
