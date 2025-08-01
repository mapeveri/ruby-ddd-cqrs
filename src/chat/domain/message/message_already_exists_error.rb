class Chat::Domain::Message::MessageAlreadyExistsError < StandardError
  def initialize(message_id)
    super("The messages #{message_id} already exists.")
  end
end
