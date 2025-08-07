class Shared::Domain::DomainEvent
  attr_reader :occurred_on

  def initialize
    @occurred_on = Time.now
  end

  class << self
    def from
      raise "Not Implemented"
    end

    def from_h
      raise "Not Implemented"
    end

    def event_name
      raise "Not Implemented"
    end
  end

  def to_h
    raise "Not Implemented"
  end
end
