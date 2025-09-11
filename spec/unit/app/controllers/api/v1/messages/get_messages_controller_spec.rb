require 'unit_helper'

RSpec.describe Api::V1::Messages::GetMessagesController, type: :controller do
  let(:chat_id) { SecureRandom.uuid }
  let(:messages_array) { [ MessageMother.random.to_h, MessageMother.random.to_h ] }
  let(:query_bus) { QueryBusMock.new }
  let(:controller) { described_class.new(query_bus: query_bus) }

  before do
    allow(controller).to receive(:params).and_return({ chat_id: chat_id })
    query_bus.add(GetMessagesQueryResponseMother.create(messages: messages_array))
  end

  after do
    query_bus.clear
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
