class MessageRepositoryMock < Chat::Domain::Message::MessageRepository
  def initialize
    @messages = []
  end

  def add(message)
    @messages << message
  end

  def clear
    @messages.clear
  end

  def stored
    @messages.dup
  end

  def find_by_id(id)
    @messages.find { |message| message.id == id }
  end

  def save(message)
    @messages << message
  end
end
