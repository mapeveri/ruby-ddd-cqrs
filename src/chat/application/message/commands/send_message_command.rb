class Chat::Application::Message::Commands::SendMessageCommand
  attr_reader :id, :sender_id, :receiver_id, :content

  def initialize(id:, sender_id:, receiver_id:, content:)
    @id = id
    @sender_id = sender_id
    @receiver_id = receiver_id
    @content = content
  end
end
