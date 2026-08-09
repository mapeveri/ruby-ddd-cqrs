#!/usr/bin/env ruby
require_relative "../config/environment"

consumer = Container[:analytics_events_consumer]
consumer.consume
