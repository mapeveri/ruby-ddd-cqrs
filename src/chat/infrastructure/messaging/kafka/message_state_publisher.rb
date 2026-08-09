class Chat::Infrastructure::Messaging::Kafka::MessageStatePublisher
  SCHEMA = {
    "type" => "struct",
    "fields" => [
      { "field" => "id", "type" => "string" },
      { "field" => "chat_id", "type" => "string" },
      { "field" => "content", "type" => "string" },
      { "field" => "sender_id", "type" => "string" },
      { "field" => "receiver_id", "type" => "string" },
      { "field" => "created_at", "type" => "int64", "name" => "org.apache.kafka.connect.data.Timestamp" },
      { "field" => "embedding", "type" => "string", "optional" => true }
    ],
    "optional" => false,
    "name" => "messages"
  }.freeze

  def initialize(kafka_producer:, enabled: true)
    @kafka_producer = kafka_producer
    @enabled = enabled
  end

  def enabled?
    @enabled
  end

  def publish_state(record)
    return unless @enabled

    @kafka_producer.produce(
      key: record.id,
      payload: { schema: SCHEMA, payload: flat_state(record) }
    )
  end

  def delete(id)
    return unless @enabled

    @kafka_producer.produce(key: id, payload: nil)
  end

  private

  def flat_state(record)
    {
      "id" => record.id,
      "chat_id" => record.chat_id,
      "content" => record.content,
      "sender_id" => record.sender_id,
      "receiver_id" => record.receiver_id,
      "created_at" => timestamp_millis(record.created_at),
      "embedding" => record.embedding.nil? ? nil : JSON.generate(record.embedding)
    }
  end

  def timestamp_millis(time)
    (time.to_f * 1000).to_i
  end
end
