#!/usr/bin/env ruby
require_relative "../config/environment"
require_relative "../src/shared/infrastructure/messaging/rabbit_mq_domain_events_consumer"

consumer = Shared::Infrastructure::Messaging::RabbitMqDomainEventsConsumer.new
consumer.consume
