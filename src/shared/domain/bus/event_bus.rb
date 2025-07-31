class Shared::Domain::Bus::EventBus
  def subscribe(event_class, handler)
    raise NotImplementedError, "#{self.class} must implement #subscribe"
  end

  def publish(events)
    raise NotImplementedError, "#{self.class} must implement #publish"
  end
end
