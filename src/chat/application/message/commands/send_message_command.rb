class Chat::Application::Message::Commands::SendMessageCommand
  attr_reader :id, :sender_id, :receiver_id, :content, :chat_id

  def initialize(id:, sender_id:, receiver_id:, content:, chat_id:)
    @id = id
    @sender_id = sender_id
    @receiver_id = receiver_id
    @content = content
    @chat_id = chat_id
  end
end
