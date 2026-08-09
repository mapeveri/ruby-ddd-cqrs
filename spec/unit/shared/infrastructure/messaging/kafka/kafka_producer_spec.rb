require 'unit_helper'

RSpec.describe Shared::Infrastructure::Messaging::Kafka::KafkaProducer do
  let(:kafka) { double("Kafka::Client") }
  let(:kafka_client) { double("KafkaClient", connection: kafka) }
  let(:producer) { described_class.new(kafka_client: kafka_client, topic: "analytics.message.events") }

  before do
    allow(kafka_client).to receive(:ensure_topic)
  end

  describe '#produce' do
    it 'delivers a json serialized message using the given key as partition key' do
      expect(kafka).to receive(:deliver_message).with(
        '{"event_type":"Chat::Domain::Message::MessageSent","id":"abc"}',
        topic: "analytics.message.events",
        key: "chat-1",
        partition_key: "chat-1"
      )

      producer.produce(
        key: "chat-1",
        payload: { event_type: "Chat::Domain::Message::MessageSent", id: "abc" }
      )
    end

    it 'ensures the topic exists on initialization' do
      expect(kafka_client).to receive(:ensure_topic).with("analytics.message.events")

      described_class.new(kafka_client: kafka_client, topic: "analytics.message.events")
    end
  end
end
