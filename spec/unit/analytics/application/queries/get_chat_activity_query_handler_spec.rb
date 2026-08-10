require 'unit_helper'

RSpec.describe Analytics::Application::Queries::GetChatActivityQueryHandler, type: :handler do
  let(:read_model) { GetChatActivityReadModelMock.new }
  let(:handler) { described_class.new(read_model: read_model) }
  let(:chat_id) { SecureRandom.uuid }

  after do
    read_model.clear
  end

  describe 'when #call is called with invalid values' do
    it 'raises an error when chat_id is invalid' do
      invalid_query = GetChatActivityQueryMother.with_invalid_chat_id

      expect {
        handler.call invalid_query
      }.to raise_error(ArgumentError)
    end
  end

  describe 'when #call is called' do
    before do
      read_model.add(
        chat_id: chat_id,
        activity: { "chat_id" => chat_id, "message_count" => "2" }
      )
    end

    it 'returns the chat activity' do
      query = GetChatActivityQueryMother.create(chat_id: chat_id)

      result = handler.call query

      expect(result.activity["chat_id"]).to eq(chat_id)
      expect(result.activity["message_count"]).to eq("2")
    end
  end
end
