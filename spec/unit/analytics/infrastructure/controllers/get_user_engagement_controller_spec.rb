require 'unit_helper'

RSpec.describe Analytics::Infrastructure::Controllers::GetUserEngagementController, type: :controller do
  let(:user_id) { SecureRandom.uuid }
  let(:engagement) { { "user_id" => user_id, "total_messages" => "5" } }
  let(:query_bus) { QueryBusMock.new }
  let(:controller) { described_class.new(query_bus: query_bus) }

  before do
    allow(controller).to receive(:params).and_return({ user_id: user_id })
    query_bus.add(GetUserEngagementQueryResponseMother.create(engagement: engagement))
  end

  after do
    query_bus.clear
  end

  describe 'when #call is called' do
    it 'renders the user engagement with status 200 Ok' do
      expect(controller).to receive(:render).with(
        hash_including(
          status: :ok,
          json: engagement
        )
      )

      controller.call
    end
  end
end
