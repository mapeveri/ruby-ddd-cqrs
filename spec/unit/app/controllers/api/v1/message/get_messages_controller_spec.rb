require 'ostruct'
require 'rails_helper'

RSpec.describe Api::V1::Message::GetMessagesController, type: :controller do
  let(:chat_id) { SecureRandom.uuid }
  let(:messages_array) { [ MessageMother.random.to_h, MessageMother.random.to_h ] }
  let(:mock_query_bus) { double('QueryBus', ask: OpenStruct.new(content: messages_array)) }
  let(:controller) { described_class.new(query_bus: mock_query_bus) }

  before do
    allow(controller).to receive(:params).and_return({ chat_id: chat_id })
  end

  describe 'when a #call method is called' do
    it 'renders messages with status 200 Ok' do
      expect(controller).to receive(:render).with(
        hash_including(
          status: :ok,
          json: messages_array
        )
      )

      controller.call
    end
  end
end
