class Shared::Infrastructure::Messaging::Kafka::KafkaProducer
  def initialize(kafka_client:, topic:, cleanup_policy: nil)
    @kafka = kafka_client.connection
    @topic = topic
    kafka_client.ensure_topic(topic, cleanup_policy: cleanup_policy)
  end

  def produce(key:, payload:)
    value = payload.nil? ? nil : JSON.generate(payload)
    @kafka.deliver_message(
      value,
      topic: @topic,
      key: key,
      partition_key: key
    )
  end
end
