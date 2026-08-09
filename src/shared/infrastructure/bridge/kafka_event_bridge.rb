class Shared::Infrastructure::Bridge::KafkaEventBridge
  RABBITMQ_USER = ENV.fetch("RABBITMQ_DEFAULT_USER")
  RABBITMQ_PASSWORD = ENV.fetch("RABBITMQ_DEFAULT_PASSWORD")
  EXCHANGE_NAME = ENV.fetch("RABBITMQ_EXCHANGE_NAME")
  QUEUE = ENV.fetch("KAFKA_BRIDGE_QUEUE_NAME")
  ROUTING_KEY = "#"

  def initialize(kafka_producer:)
    @kafka_producer = kafka_producer
  end

  def consume
    connection = Bunny.new(
      username: RABBITMQ_USER,
      password: RABBITMQ_PASSWORD
    ).start

    channel = connection.create_channel
    exchange = channel.topic(EXCHANGE_NAME, durable: true)
    queue = channel.queue(QUEUE, durable: true)
    queue.bind(exchange, routing_key: ROUTING_KEY)

    Rails.logger.info("[KafkaEventBridge] -> Bridging domain events to Kafka...")

    queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
      begin
        event = deserialize(body)
        call(event)
      rescue => e
        Rails.logger.error("[KafkaEventBridge] Error: #{e.message}")
      ensure
        channel.ack(delivery_info.delivery_tag)
      end
    end
  end

  def call(event)
    @kafka_producer.produce(
      key: partition_key(event),
      payload: event.to_h.merge(event_type: event.class.name)
    )
  end

  private

    def deserialize(body)
      data = JSON.parse(body)
      Object.const_get(data["event_type"]).from_h(data)
    end

    def partition_key(event)
      return event.chat_id.to_s if event.respond_to?(:chat_id)

      event.class.name
    end
end
