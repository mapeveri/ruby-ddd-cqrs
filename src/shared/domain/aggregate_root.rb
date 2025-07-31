class Shared::Domain::AggregateRoot
  def initialize
    @domain_events = []
  end

  def record(event)
    @domain_events << event
  end

  def pull_domain_events
    events = @domain_events.dup
    @domain_events.clear
    events
  end
end
