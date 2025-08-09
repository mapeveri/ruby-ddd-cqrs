require 'rails_helper'

RSpec.describe "Given a user that want to search message in a chat", type: :request do
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
      content: "Hello world"
    }
  end
  let(:search) { "Give messages where the text is Hello world" }

  describe "When the url is GET /api/v1/messages/search/:chat_id" do
    before do
      post '/api/v1/messages', params: message_payload
    end

    it "should return 200 OK and find a message" do
      get "/api/v1/messages/search/#{chat_id}?q=#{search}"

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json).to be_an(Array)
      expect(json.length).to eq(1)
    end
  end
end
