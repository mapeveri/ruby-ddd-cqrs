class MessageRepositoryMock < Chat::Domain::Message::MessageRepository
  def initialize
    @messages = []
  end

  def save(message)
    @messages << message
  end

  def stored
    @messages.dup
  end

  protected

  def clear
    @messages.clear
  end
end
