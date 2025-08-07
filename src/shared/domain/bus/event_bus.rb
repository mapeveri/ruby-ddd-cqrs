class Shared::Domain::Bus::EventBus
  def publish(events)
    raise NotImplementedError, "#{self.class} must implement #publish"
  end
end
