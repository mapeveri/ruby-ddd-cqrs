require 'rails_helper'

RSpec.describe "Api::V1::Users::OnlineUsers", type: :request do
  describe "GET /api/v1/users/online_users" do
    before do
      session_data = { token: "some-token", name: "Guest_1234" }.to_json
      $redis.set("session:123", session_data)
    end

    after do
      $redis.del("session:123")
    end

    it "returns the list of online users with token and name" do
      get "/api/v1/users/online_users"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).not_to be_empty

      json.each do |user|
        expect(user).to include("token", "name")
        expect(user["name"]).to match(/^Guest_/)
      end
    end
  end
end
