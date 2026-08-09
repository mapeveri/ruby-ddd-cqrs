require 'unit_helper'

RSpec.describe Analytics::Infrastructure::Persistence::ActiveRecord::Repositories::AnalyticsSnapshotRepository do
  let(:repository) { described_class.new }

  describe '#save and #find' do
    it 'persists and retrieves a snapshot' do
      repository.save(
        projection_key: "chat_activity",
        state: { "c1" => { "message_count" => "5" } },
        kafka_offset: 100
      )

      snapshot = repository.find("chat_activity")

      expect(snapshot).not_to be_nil
      expect(snapshot).to be_a(Analytics::Domain::AnalyticsSnapshot)
      expect(snapshot.projection_key).to eq("chat_activity")
      expect(snapshot.state).to eq("c1" => { "message_count" => "5" })
      expect(snapshot.kafka_offset).to eq(100)
    end

    it 'updates an existing snapshot instead of creating a new one' do
      repository.save(projection_key: "chat_activity", state: { "c1" => {} }, kafka_offset: 100)
      repository.save(
        projection_key: "chat_activity",
        state: { "c1" => { "message_count" => "9" } },
        kafka_offset: 200
      )

      snapshot = repository.find("chat_activity")

      expect(snapshot.state).to eq("c1" => { "message_count" => "9" })
      expect(snapshot.kafka_offset).to eq(200)
      expect(AnalyticsSnapshotRecord.count).to eq(1)
    end

    it 'returns nil when no snapshot exists' do
      expect(repository.find("missing")).to be_nil
    end
  end
end
