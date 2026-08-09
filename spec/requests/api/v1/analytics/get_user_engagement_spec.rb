require 'rails_helper'

RSpec.describe "Given a user that wants the user engagement analytics", type: :request do
  let(:chat_id) { SecureRandom.uuid }
  let(:sender_id) { SecureRandom.uuid }
  let(:receiver_id) { SecureRandom.uuid }

  def send_message
    Analytics::Infrastructure::Persistence::AnalyticsDb::MessageRecord.create!(
      id: SecureRandom.uuid,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: "hello",
      chat_id: chat_id,
      created_at: Time.now
    )
  end

  describe "When the url is GET /api/v1/analytics/user_engagement/:user_id" do
    before do
      3.times { send_message }
    end

    it "returns 200 OK with the user engagement" do
      get "/api/v1/analytics/user_engagement/#{sender_id}"

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json["user_id"]).to eq(sender_id)
      expect(json["total_messages"]).to eq(3)
      expect(json["chats"]).to eq([ chat_id ])
    end
  end

  describe "When there is no engagement for the user" do
    it "returns 200 OK with a null payload" do
      get "/api/v1/analytics/user_engagement/#{SecureRandom.uuid}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq("null")
    end
  end
end
