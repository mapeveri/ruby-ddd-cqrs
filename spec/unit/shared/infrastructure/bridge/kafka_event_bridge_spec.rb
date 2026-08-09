require 'unit_helper'

class PartitionKeyStubEvent
  def to_h
    { id: "1" }
  end
end

RSpec.describe Shared::Infrastructure::Bridge::KafkaEventBridge do
  let(:kafka_producer) { double("KafkaProducer") }
  let(:bridge) { described_class.new(kafka_producer: kafka_producer) }
  let(:event) { Chat::Domain::Message::MessageSent.from(MessageMother.random) }

  describe '#call' do
    it 'produces the serialized event to the analytics topic keyed by chat_id' do
      expect(kafka_producer).to receive(:produce).with(
        key: event.chat_id.to_s,
        payload: event.to_h.merge(event_type: event.class.name)
      )

      bridge.call(event)
    end
  end

  describe '#partition_key' do
    it 'uses the chat_id when the event has one' do
      expect(bridge.send(:partition_key, event)).to eq(event.chat_id.to_s)
    end

    it 'falls back to the event class name otherwise' do
      other = PartitionKeyStubEvent.new
      expect(bridge.send(:partition_key, other)).to eq("PartitionKeyStubEvent")
    end
  end

  describe '#deserialize' do
    it 'rehydrates the event from the serialized payload' do
      payload = event.to_h.merge(event_type: event.class.name)
      rehydrated = bridge.send(:deserialize, JSON.generate(payload))

      expect(rehydrated).to be_a(Chat::Domain::Message::MessageSent)
      expect(rehydrated.id.to_s).to eq(event.id.to_s)
      expect(rehydrated.chat_id.to_s).to eq(event.chat_id.to_s)
    end
  end
end
