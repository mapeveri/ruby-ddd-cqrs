class Shared::Domain::DomainEvents::DomainEvent
  include Shared::Domain::DomainEvents::SerializableEvent

  attr_reader :occurred_on, :event_type

  def initialize(occurred_on: Time.now, event_type: self.class.event_name)
    @occurred_on = occurred_on
    @event_type = event_type
  end

  class << self
    def from
      raise "Not Implemented"
    end

    def event_name
      raise "Not Implemented"
    end
  end
end
