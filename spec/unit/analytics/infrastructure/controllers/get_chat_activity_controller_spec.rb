require 'unit_helper'

RSpec.describe Analytics::Infrastructure::Controllers::GetChatActivityController, type: :controller do
  let(:chat_id) { SecureRandom.uuid }
  let(:activity) { { "chat_id" => chat_id, "message_count" => "3" } }
  let(:query_bus) { QueryBusMock.new }
  let(:controller) { described_class.new(query_bus: query_bus) }

  before do
    allow(controller).to receive(:params).and_return({ chat_id: chat_id })
    query_bus.add(GetChatActivityQueryResponseMother.create(activity: activity))
  end

  after do
    query_bus.clear
  end

  describe 'when #call is called' do
    it 'renders the chat activity with status 200 Ok' do
      expect(controller).to receive(:render).with(
        hash_including(
          status: :ok,
          json: activity
        )
      )

      controller.call
    end
  end
end
