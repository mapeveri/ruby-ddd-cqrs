require 'rails_helper'

RSpec.describe "Given a user want to see the online users", type: :request do
  describe "When the url is GET /api/v1/users/online_users" do
    before do
      session_data = { user_id: "some-token", name: "Guest_1234" }.to_json
      $redis.set("session:123", session_data)
    end

    it "should return the list of online users with token and name" do
      get "/api/v1/users/online_users"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).not_to be_empty

      json.each do |user|
        expect(user).to include("user_id", "name")
        expect(user["name"]).to match(/^Guest_/)
      end
    end
  end
end
