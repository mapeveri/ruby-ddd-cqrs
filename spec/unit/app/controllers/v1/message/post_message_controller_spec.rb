require 'rails_helper'

RSpec.describe V1::Message::PostMessageController, type: :controller do
  let(:sender_id) { SecureRandom.uuid }
  let(:receiver_id) { SecureRandom.uuid }
  let(:content) { 'Hello, Bob!' }
  let(:params_hash) do
    {
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content
    }
  end
  let(:mock_command_bus) { double('CommandBus', call: true) }

  before do
    allow(Container).to receive(:[]).with(:command_bus).and_return(mock_command_bus)
    allow(controller).to receive(:params).and_return(params_hash)
  end

  describe 'when a #call method is called' do
    it 'renders with status 201 Created' do
      expect(controller).to receive(:render).with(hash_including(status: :created))

      controller.call
    end
  end
end
