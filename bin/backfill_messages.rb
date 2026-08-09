#!/usr/bin/env ruby
require_relative "../config/environment"

publisher = Container[:message_state_publisher]

unless publisher.enabled?
  puts "[backfill] MessageStatePublisher is disabled in #{Rails.env}; nothing to do"
  exit 0
end

puts "[backfill] Publishing full state for #{MessageRecord.count} messages to #{ENV.fetch("KAFKA_MESSAGE_STATE_TOPIC")}..."

MessageRecord.find_each do |record|
  publisher.publish_state(record)
end

puts "[backfill] Done. Backfill is idempotent: the sink upserts by id."
