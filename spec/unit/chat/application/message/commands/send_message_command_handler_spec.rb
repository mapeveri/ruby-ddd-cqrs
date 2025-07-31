require 'rails_helper'

RSpec.describe Chat::Application::Message::Commands::SendMessageCommandHandler, type: :handler do
  let(:message_repository) { MessageRepositoryMock.new }
  let(:event_bus) { EventBusMock.new }
  let(:handler) { described_class.new(message_repository: message_repository, event_bus: event_bus) }

  after do
    message_repository.clear
  end

  describe 'when #call is called with invalid values' do
    invalid_cases = {
      'id' => :with_invalid_id,
      'sender_id' => :with_invalid_sender_id,
      'receiver_id' => :with_invalid_receiver_id,
      'content' => :with_invalid_content
    }

    invalid_cases.each do |field, method|
      it "should raise an error when #{field} is invalid" do
        invalid_command = SendMessageCommandMother.send(method)

        expect {
          handler.call invalid_command
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'when a #call method is called with invalid data' do
    message_id = SecureRandom.uuid
    before do
      message_repository.add(MessageMother.with_id(message_id))
    end

    it 'should raise an error when the message already exists' do
      command = SendMessageCommandMother.with_id(message_id)

      handler.call command

      expect {
        handler.call command
      }.to raise_error(Chat::Domain::Message::MessageAlreadyExistsError)
    end
  end

  describe 'when a #call method is called' do
    it 'should send a message' do
      command = SendMessageCommandMother.random

      handler.call command

      expect(message_repository.stored.size).to eq(1)
      expect(message_repository.stored.first).to be_a(Chat::Domain::Message::Message)
    end

    it 'should publish an event' do
      command = SendMessageCommandMother.random

      handler.call command

      expect(event_bus.domain_events.size).to eq(1)
      expect(event_bus.domain_events.first).to be_a(Chat::Domain::Message::MessageSent)
    end
  end
end
