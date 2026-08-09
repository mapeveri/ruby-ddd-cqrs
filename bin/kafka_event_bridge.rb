#!/usr/bin/env ruby
require_relative "../config/environment"
require_relative "../src/shared/infrastructure/bridge/kafka_event_bridge"

kafka_client = Shared::Infrastructure::Messaging::Kafka::KafkaClient.new
producer = Shared::Infrastructure::Messaging::Kafka::KafkaProducer.new(
  kafka_client: kafka_client,
  topic: ENV.fetch("KAFKA_ANALYTICS_TOPIC")
)

bridge = Shared::Infrastructure::Bridge::KafkaEventBridge.new(kafka_producer: producer)
bridge.consume
