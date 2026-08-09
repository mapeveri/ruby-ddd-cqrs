require 'unit_helper'

RSpec.describe Analytics::Infrastructure::Consumers::AnalyticsEventsConsumer do
  let(:kafka) { double("Kafka::Client") }
  let(:kafka_client) { double("KafkaClient", connection: kafka) }
  let(:chat_activity_projector) { double("ChatActivityProjector") }
  let(:user_engagement_projector) { double("UserEngagementProjector") }
  let(:snapshot_manager) { double("SnapshotManager") }
  let(:consumer) do
    described_class.new(
      kafka_client: kafka_client,
      topic: "analytics.message.events",
      group_id: "analytics.projections",
      chat_activity_projector: chat_activity_projector,
      user_engagement_projector: user_engagement_projector,
      snapshot_manager: snapshot_manager
    )
  end

  describe '#handle' do
    let(:event) { Chat::Domain::Message::MessageSent.from(MessageMother.random) }
    let(:message) do
      instance_double(
        "Kafka::FetchedMessage",
        value: JSON.generate(event.to_h.merge(event_type: event.class.name)),
        offset: 42
      )
    end

    it 'projects a MessageSent event into both projections and tracks snapshots' do
      expect(chat_activity_projector).to receive(:project_message_sent) do |rehydrated|
        expect(rehydrated).to be_a(Chat::Domain::Message::MessageSent)
        expect(rehydrated.id.to_s).to eq(event.id.to_s)
      end
      expect(user_engagement_projector).to receive(:project_message_sent) do |rehydrated|
        expect(rehydrated).to be_a(Chat::Domain::Message::MessageSent)
      end

      expect(chat_activity_projector).to receive(:snapshot_state).and_return({ "c1" => {} })
      expect(user_engagement_projector).to receive(:snapshot_state).and_return({ "u1" => {} })

      expect(snapshot_manager).to receive(:track).with(
        projection_key: "chat_activity",
        state: { "c1" => {} },
        kafka_offset: 42
      )
      expect(snapshot_manager).to receive(:track).with(
        projection_key: "user_engagement",
        state: { "u1" => {} },
        kafka_offset: 42
      )

      consumer.handle(message)
    end

    it 'ignores events without a projection' do
      expect(chat_activity_projector).not_to receive(:project_message_sent)
      expect(snapshot_manager).not_to receive(:track)

      other_message = instance_double(
        "Kafka::FetchedMessage",
        value: JSON.generate({ event_type: "Some::Unknown::Event" }),
        offset: 1
      )

      expect {
        consumer.handle(other_message)
      }.not_to raise_error
    end
  end

  describe '#consume' do
    it 'subscribes to the topic, restores snapshots and processes messages' do
      allow(kafka_client).to receive(:ensure_topic)

      consumer_instance = double("Kafka::Consumer")
      expect(kafka).to receive(:consumer).with(group_id: "analytics.projections").and_return(consumer_instance)
      expect(consumer_instance).to receive(:subscribe).with("analytics.message.events", start_from_beginning: true)

      expect(consumer).to receive(:restore_from_snapshots)
      expect(consumer).to receive(:handle)

      messages = [double("message")]
      expect(consumer_instance).to receive(:each_message).and_yield(messages.first)
      expect(consumer_instance).to receive(:mark_message_as_processed).with(messages.first)

      consumer.consume
    end
  end

  describe '#restore_from_snapshots' do
    it 'restores both projections when snapshots exist' do
      chat_snapshot = Analytics::Domain::AnalyticsSnapshot.new(
        projection_key: "chat_activity",
        state: { "c1" => {} },
        kafka_offset: 1
      )
      user_snapshot = Analytics::Domain::AnalyticsSnapshot.new(
        projection_key: "user_engagement",
        state: { "u1" => {} },
        kafka_offset: 1
      )

      expect(snapshot_manager).to receive(:restore).with(projection_key: "chat_activity").and_return(chat_snapshot)
      expect(snapshot_manager).to receive(:restore).with(projection_key: "user_engagement").and_return(user_snapshot)
      expect(chat_activity_projector).to receive(:restore).with({ "c1" => {} })
      expect(user_engagement_projector).to receive(:restore).with({ "u1" => {} })

      consumer.send(:restore_from_snapshots)
    end

    it 'skips projections without a snapshot' do
      expect(snapshot_manager).to receive(:restore).with(projection_key: "chat_activity").and_return(nil)
      expect(snapshot_manager).to receive(:restore).with(projection_key: "user_engagement").and_return(nil)
      expect(chat_activity_projector).not_to receive(:restore)
      expect(user_engagement_projector).not_to receive(:restore)

      consumer.send(:restore_from_snapshots)
    end
  end
end
