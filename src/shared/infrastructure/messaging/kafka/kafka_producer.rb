class Shared::Infrastructure::Messaging::Kafka::KafkaProducer
  def initialize(kafka_client:, topic:)
    @kafka = kafka_client.connection
    @topic = topic
    kafka_client.ensure_topic(topic)
  end

  def produce(key:, payload:)
    @kafka.deliver_message(
      JSON.generate(payload),
      topic: @topic,
      key: key,
      partition_key: key
    )
  end
end
