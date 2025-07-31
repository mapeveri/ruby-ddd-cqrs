class Shared::Domain::DomainEvent
  attr_reader :occurred_on

  def initialize
    @occurred_on = Time.now
  end
end
