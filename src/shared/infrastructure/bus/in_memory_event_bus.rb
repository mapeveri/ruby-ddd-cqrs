class Shared::Infrastructure::Bus::InMemoryEventBus < Shared::Domain::Bus::EventBus
  def initialize
    super()
  end

  def publish(events)
    Array(events).each do |event|
      event_class = event.class
      handlers = EventSubscriptions.registry[event_class] || []
      handlers.each { |handler| handler.call(event) }
    end
  end
end
