require 'unit_helper'

RSpec.describe Shared::Infrastructure::Messaging::Kafka::KafkaClient do
  let(:connection) { double("Kafka::Client") }
  let(:client) { described_class.new(brokers: "localhost:9092", logger: Logger.new(nil)) }

  before do
    allow(client).to receive(:connection).and_return(connection)
  end

  describe '#ensure_topic' do
    it 'creates the topic when it does not exist' do
      expect(connection).to receive(:create_topic).with(
        "analytics.message.events",
        num_partitions: 1,
        replication_factor: 1
      )

      client.ensure_topic("analytics.message.events")
    end

    it 'does not raise when the topic already exists' do
      allow(connection).to receive(:create_topic).and_raise(Kafka::TopicAlreadyExists)

      expect {
        client.ensure_topic("analytics.message.events")
      }.not_to raise_error
    end

    it 'returns the cached connection' do
      expect(client.connection).to equal(client.connection)
    end
  end
end
