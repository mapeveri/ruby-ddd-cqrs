class Chat::Infrastructure::Persistence::ActiveRecord::Services::MessageEmbeddingWriter
  def initialize(message_state_publisher:)
    @message_state_publisher = message_state_publisher
  end

  def update_embedding(id, embedding)
    MessageRecord.where(id: id).update(embedding: embedding)
    publish_state(id)
  end

  private

  def publish_state(id)
    record = MessageRecord.find_by(id: id.to_s)
    return unless record

    @message_state_publisher.publish_state(record)
  end
end
