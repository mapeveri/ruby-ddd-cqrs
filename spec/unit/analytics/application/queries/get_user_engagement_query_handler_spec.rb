require 'unit_helper'

RSpec.describe Analytics::Application::Queries::GetUserEngagementQueryHandler, type: :handler do
  let(:read_model) { GetUserEngagementReadModelMock.new }
  let(:handler) { described_class.new(read_model: read_model) }
  let(:user_id) { SecureRandom.uuid }

  after do
    read_model.clear
  end

  describe 'when #call is called with invalid values' do
    it 'raises an error when user_id is invalid' do
      invalid_query = GetUserEngagementQueryMother.with_invalid_user_id

      expect {
        handler.call invalid_query
      }.to raise_error(ArgumentError)
    end
  end

  describe 'when #call is called' do
    before do
      read_model.add(
        user_id: user_id,
        engagement: { "user_id" => user_id, "total_messages" => "3" }
      )
    end

    it 'returns the user engagement' do
      query = GetUserEngagementQueryMother.create(user_id: user_id)

      result = handler.call query

      expect(result.engagement["user_id"]).to eq(user_id)
      expect(result.engagement["total_messages"]).to eq("3")
    end
  end
end
