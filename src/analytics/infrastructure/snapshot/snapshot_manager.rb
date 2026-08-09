class Analytics::Infrastructure::Snapshot::SnapshotManager
  def initialize(snapshot_repository:, snapshot_interval:)
    @snapshot_repository = snapshot_repository
    @snapshot_interval = snapshot_interval
    @processed = Hash.new(0)
  end

  def track(projection_key:, state:, kafka_offset:)
    @processed[projection_key] += 1

    if @processed[projection_key] % @snapshot_interval == 0
      @snapshot_repository.save(
        projection_key: projection_key,
        state: state,
        kafka_offset: kafka_offset
      )
    end
  end

  def restore(projection_key:)
    @snapshot_repository.find(projection_key)
  end
end
