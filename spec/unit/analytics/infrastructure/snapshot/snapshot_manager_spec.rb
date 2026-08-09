require 'unit_helper'

RSpec.describe Analytics::Infrastructure::Snapshot::SnapshotManager do
  let(:repository) { double("SnapshotRepository") }
  let(:manager) { described_class.new(snapshot_repository: repository, snapshot_interval: 2) }

  describe '#track' do
    it 'saves a snapshot every interval of processed events' do
      calls = []
      allow(repository).to receive(:save) { |**args| calls << args }

      manager.track(projection_key: "chat_activity", state: { "c1" => {} }, kafka_offset: 1)
      expect(calls).to be_empty

      manager.track(projection_key: "chat_activity", state: { "c1" => {} }, kafka_offset: 2)
      expect(calls.size).to eq(1)
      expect(calls.first).to eq(
        projection_key: "chat_activity",
        state: { "c1" => {} },
        kafka_offset: 2
      )
    end

    it 'keeps counters independent per projection' do
      calls = []
      allow(repository).to receive(:save) { |**args| calls << args }

      manager.track(projection_key: "chat_activity", state: {}, kafka_offset: 1)
      manager.track(projection_key: "user_engagement", state: {}, kafka_offset: 1)
      manager.track(projection_key: "chat_activity", state: {}, kafka_offset: 2)

      expect(calls.size).to eq(1)
      expect(calls.first).to eq(projection_key: "chat_activity", state: {}, kafka_offset: 2)
    end
  end

  describe '#restore' do
    it 'delegates to the repository' do
      snapshot = Analytics::Domain::AnalyticsSnapshot.new(
        projection_key: "chat_activity",
        state: {},
        kafka_offset: 10
      )

      expect(repository).to receive(:find).with("chat_activity").and_return(snapshot)

      expect(manager.restore(projection_key: "chat_activity")).to eq(snapshot)
    end
  end
end
