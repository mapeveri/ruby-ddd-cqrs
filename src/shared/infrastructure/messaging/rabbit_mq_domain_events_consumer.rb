class Shared::Infrastructure::Messaging::RabbitMqDomainEventsConsumer
  EXCHANGE_NAME = ENV.fetch("RABBITMQ_EXCHANGE_NAME")
  QUEUE = ENV.fetch("RABBITMQ_QUEUE_NAME")
  RABBITMQ_USER = ENV.fetch("RABBITMQ_DEFAULT_USER")
  RABBITMQ_PASSWORD = ENV.fetch("RABBITMQ_DEFAULT_PASSWORD")

  def consume
    Rails.logger.info("[RabbitMqDomainEventsConsumer] -> Consuming domain events...")
    connection = Bunny.new(
      username: RABBITMQ_USER,
      password: RABBITMQ_PASSWORD
    ).start

    Rails.logger.info("[RabbitMqDomainEventsConsumer] -> Connecting domain events...")
    channel = connection.create_channel
    exchange = channel.topic(EXCHANGE_NAME, durable: true)
    queue = channel.queue(QUEUE, durable: true)
    queue.bind(exchange, routing_key: "#")

    Rails.logger.info("[RabbitMqDomainEventsConsumer] -> Connection successfully...")
    registry = EventSubscriptions.registry

    queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
      begin
        Rails.logger.info("[RabbitMqDomainEventsConsumer] -> Consuming domain event #{body}")
        data = JSON.parse(body)
        event_type = data["event_type"]
        event_class = Object.const_get(event_type)

        event = event_class.from_h(data)

        handlers = registry[event_class]
        if handlers
          handlers.each { |handler| handler.call(event) }
        else
          Rails.logger.warn("[RabbitMQ] No handler for #{event_type}")
        end
      rescue => e
        Rails.logger.error("[RabbitMQ] Error: #{e.message}")
      ensure
        channel.ack(delivery_info.delivery_tag)
      end
    end
  end
end
