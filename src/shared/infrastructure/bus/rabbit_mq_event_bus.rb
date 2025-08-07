require "bunny"

class Shared::Infrastructure::Bus::RabbitMqEventBus < Shared::Domain::Bus::EventBus
  EXCHANGE_NAME = ENV.fetch("RABBITMQ_EXCHANGE_NAME")
  RABBITMQ_USER = ENV.fetch("RABBITMQ_DEFAULT_USER")
  RABBITMQ_PASSWORD = ENV.fetch("RABBITMQ_DEFAULT_PASSWORD")

  def initialize
    @connection = Bunny.new(
      username: RABBITMQ_USER,
      password: RABBITMQ_PASSWORD
    ).start
    @channel = @connection.create_channel
    @exchange = @channel.topic(EXCHANGE_NAME, durable: true)
  end

  def publish(events)
    events.each do |event|
      payload = event.to_h.merge(event_type: event.class.name).to_json
      routing_key = event.class.event_name
      @exchange.publish(payload, routing_key: routing_key, persistent: true)
    end
  end
end
