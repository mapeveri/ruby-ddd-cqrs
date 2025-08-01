require 'rails_helper'

RSpec.describe "Given a GetMessagesController", type: :request do
  let(:chat_id) { SecureRandom.uuid }
  let(:id) { SecureRandom.uuid }
  let(:sender_id) { SecureRandom.uuid }
  let(:receiver_id) { SecureRandom.uuid }

  let(:message_payload) do
    {
      id: id,
      chat_id: chat_id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: "Hola mundo"
    }
  end

  describe "GET /api/v1/messages/:chat_id" do
    it "returns 200 OK" do
      post "/api/v1/messages", params: message_payload
      get "/api/v1/messages/#{chat_id}"

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json).to be_an(Array)
      expect(json.length).to eq(1)
    end
  end
end
