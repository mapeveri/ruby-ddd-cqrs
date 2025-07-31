require 'rails_helper'

RSpec.describe Chat::Application::Message::Commands::SendMessageCommandHandler, type: :handler do
  let(:message_repository) { MessageRepositoryMock.new }
  let(:handler) { described_class.new(message_repository: message_repository) }

  describe 'when a #call method is called' do
    it 'should create a message' do
      command = SendMessageCommandMother.random

      handler.call command

      expect(message_repository.stored.size).to eq(1)
    end
  end
end
