class Shared::Infrastructure::Bus::InMemoryEventBus < Shared::Domain::Bus::EventBus
  def initialize
    super()
    @subscribers = Hash.new { |h, k| h[k] = [] }
  end

  def subscribe(event_class, handler)
    @subscribers[event_class] << handler
  end

  def publish(events)
    events.each do |event|
      event_class = event.class
      @subscribers[event_class].each { |handler| handler.call(event) }
    end
  end
end
