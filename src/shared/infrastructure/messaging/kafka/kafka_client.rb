class Shared::Infrastructure::Messaging::Kafka::KafkaClient
  def initialize(brokers: ENV.fetch("KAFKA_BROKERS"), logger: Rails.logger)
    @brokers = brokers.split(",")
    @logger = logger
  end

  def connection
    @connection ||= Kafka.new(@brokers, logger: @logger)
  end

  def ensure_topic(topic, num_partitions: 1, replication_factor: 1, cleanup_policy: nil)
    config = cleanup_policy ? { "cleanup.policy" => cleanup_policy } : {}
    connection.create_topic(
      topic,
      num_partitions: num_partitions,
      replication_factor: replication_factor,
      config: config
    )
    @logger.info("[KafkaClient] Topic #{topic} created")
  rescue Kafka::Error
    @logger.info("[KafkaClient] Topic #{topic} already exists")
  end
end
