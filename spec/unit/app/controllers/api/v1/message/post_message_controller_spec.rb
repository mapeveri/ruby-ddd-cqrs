require 'rails_helper'

RSpec.describe Api::V1::Message::PostMessageController, type: :controller do
  let(:id) { SecureRandom.uuid }
  let(:sender_id) { SecureRandom.uuid }
  let(:receiver_id) { SecureRandom.uuid }
  let(:chat_id) { SecureRandom.uuid }
  let(:content) { 'Hello, Bob!' }
  let(:params_hash) do
    {
      id: id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      chat_id: chat_id
    }
  end
  let(:mock_command_bus) { double('CommandBus', execute: true) }
  let(:controller) { described_class.new(command_bus: mock_command_bus) }

  before do
    allow(controller).to receive(:params).and_return(params_hash)
  end

  describe 'when a #call method is called' do
    it 'renders with status 201 Created' do
      expect(controller).to receive(:render).with(hash_including(status: :created))

      controller.call
    end
  end
end
