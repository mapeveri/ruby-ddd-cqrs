require 'unit_helper'

RSpec.describe Chat::Infrastructure::Messaging::Kafka::MessageStatePublisher do
  let(:producer) { double("KafkaProducer") }
  let(:publisher) { described_class.new(kafka_producer: producer, enabled: true) }
  let(:created_at) { Time.utc(2026, 1, 1, 12, 0, 0) }
  let(:record) do
    MessageRecord.new(
      id: "msg-1",
      chat_id: "chat-1",
      content: "hello",
      sender_id: "user-1",
      receiver_id: "user-2",
      created_at: created_at,
      embedding: [ 0.1, 0.2 ]
    )
  end

  describe '#publish_state' do
    it 'publishes the full flat state keyed by the message id' do
      expect(producer).to receive(:produce).with(
        key: "msg-1",
        payload: {
          schema: described_class::SCHEMA,
          payload: {
            "id" => "msg-1",
            "chat_id" => "chat-1",
            "content" => "hello",
            "sender_id" => "user-1",
            "receiver_id" => "user-2",
            "created_at" => (created_at.to_f * 1000).to_i,
            "embedding" => "[0.1,0.2]"
          }
        }
      )

      publisher.publish_state(record)
    end

    it 'does not publish when disabled' do
      disabled = described_class.new(kafka_producer: producer, enabled: false)

      expect(producer).not_to receive(:produce)

      disabled.publish_state(record)
    end
  end

  describe '#delete' do
    it 'publishes a tombstone for the id' do
      expect(producer).to receive(:produce).with(key: "msg-1", payload: nil)

      publisher.delete("msg-1")
    end
  end
end
