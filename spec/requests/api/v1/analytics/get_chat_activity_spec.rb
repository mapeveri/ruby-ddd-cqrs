require 'rails_helper'

RSpec.describe "Given a user that wants the chat activity analytics", type: :request do
  let(:chat_id) { SecureRandom.uuid }
  let(:sender_id) { SecureRandom.uuid }
  let(:receiver_id) { SecureRandom.uuid }
  let(:projector) { Analytics::Infrastructure::Persistence::Redis::Projector::ChatActivityProjector.new }

  def send_message
    projector.project_message_sent(
      Chat::Domain::Message::MessageSent.new(**{
        id: SecureRandom.uuid,
        sender_id: sender_id,
        receiver_id: receiver_id,
        content: "hello",
        chat_id: chat_id,
        created_at: Time.now
      })
    )
  end

  describe "When the url is GET /api/v1/analytics/chat_activity/:chat_id" do
    before do
      2.times { send_message }
    end

    it "returns 200 OK with the chat activity projection" do
      get "/api/v1/analytics/chat_activity/#{chat_id}"

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json["chat_id"]).to eq(chat_id)
      expect(json["message_count"]).to eq("2")
      expect(json["unique_participants"]).to eq("2")
    end
  end

  describe "When there is no activity for the chat" do
    it "returns 200 OK with a null payload" do
      get "/api/v1/analytics/chat_activity/#{SecureRandom.uuid}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq("null")
    end
  end
end
