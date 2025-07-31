class Chat::Infrastructure::Persistence::Repositories::ActiveRecordMessageRepository < Chat::Domain::Message::MessageRepository
  def initialize
    @messages = []
  end

  def find_by_id(id)
    @messages.each { |message| message.id == id }
  end

  def save(message)
    @messages << message
  end
end
