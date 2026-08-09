#!/usr/bin/env ruby
require_relative "../config/environment"

kafka_client = Shared::Infrastructure::Messaging::Kafka::KafkaClient.new
kafka_client.ensure_topic(ENV.fetch("KAFKA_MESSAGE_STATE_TOPIC"), cleanup_policy: "compact")

puts "[bootstrap] Topic #{ENV.fetch("KAFKA_MESSAGE_STATE_TOPIC")} ready (cleanup.policy=compact)"
