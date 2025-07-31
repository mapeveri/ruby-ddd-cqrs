class EventBusMock < Shared::Domain::Bus::EventBus
  attr_reader :domain_events

  def initialize
    @domain_events = []
  end

  def subscribe(event_class, handler)
    puts "Subscribing #{event_class} to #{handler}"
  end

  def publish(*events)
    @domain_events.concat(events)
  end
end
