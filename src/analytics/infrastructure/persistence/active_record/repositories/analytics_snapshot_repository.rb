module Analytics
  class Infrastructure::Persistence::ActiveRecord::Repositories::AnalyticsSnapshotRepository
    def save(projection_key:, state:, kafka_offset:)
      record = Analytics::Infrastructure::Persistence::ActiveRecord::AnalyticsSnapshotRecord.find_or_initialize_by(projection_key: projection_key)
      record.update!(state: state, kafka_offset: kafka_offset)
    end

    def find(projection_key)
      record = Analytics::Infrastructure::Persistence::ActiveRecord::AnalyticsSnapshotRecord.find_by(projection_key: projection_key)
      return nil unless record

      Analytics::Domain::AnalyticsSnapshot.new(
        projection_key: record.projection_key,
        state: record.state,
        kafka_offset: record.kafka_offset
      )
    end
  end
end
