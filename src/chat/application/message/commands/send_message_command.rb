class Chat::Application::Message::Commands::SendMessageCommand
  def initialize(sender_id:, receiver_id:, content:)
    @sender_id = sender_id
    @receiver_id = receiver_id
    @content = content
  end
end
