class Analytics::Domain::AnalyticsSnapshot
  attr_reader :projection_key, :state, :kafka_offset

  def initialize(projection_key:, state:, kafka_offset:)
    @projection_key = projection_key
    @state = state
    @kafka_offset = kafka_offset
  end
end
