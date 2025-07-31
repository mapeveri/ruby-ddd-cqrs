class Chat::Domain::Message::MessageAlreadyExistsError < StandardError
  def initialize(message_id)
    super("The message #{message_id} already exists.")
  end
end
