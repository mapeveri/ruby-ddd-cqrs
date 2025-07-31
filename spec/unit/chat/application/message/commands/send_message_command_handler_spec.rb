require 'rails_helper'

RSpec.describe Chat::Application::Message::Commands::SendMessageCommandHandler, type: :handler do
  let(:message_repository) { MessageRepositoryMock.new }
  let(:event_bus) { EventBusMock.new }
  let(:handler) { described_class.new(message_repository: message_repository, event_bus: event_bus) }

  describe 'when a #call method is called' do
    it 'should send a message' do
      command = SendMessageCommandMother.random

      handler.call command

      expect(message_repository.stored.size).to eq(1)
    end

    it 'should publish an event' do
      command = SendMessageCommandMother.random

      handler.call command

      expect(event_bus.domain_events.size).to eq(1)
    end
  end
end
