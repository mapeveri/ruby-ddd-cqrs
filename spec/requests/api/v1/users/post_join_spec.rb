require 'rails_helper'

RSpec.describe "Given a user want to join a chat", type: :request do
  let(:user_id) { SecureRandom.uuid }

  before do
    $redis.del("session:#{user_id}")
  end

  describe "When user is not already log-in and want to join a chat" do
    it "should return a new user_id and a name" do
      post "/api/v1/users/join", params: {
        user_id: user_id
      }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to have_key("user_id")
      expect(json).to have_key("name")
      expect(json["name"]).to match(/^Guest_/)
    end
  end

  describe "When a user is already log-in and want to join a chat" do
    let(:cached_name) { "Guest_123" }
    let(:cached_data) { { user_id: user_id, name: cached_name } }

    before do
      $redis.set("session:#{user_id}", cached_data.to_json)
    end

    it "should return the user_id and name from cache without creating a new one" do
      post "/api/v1/users/join", params: {
        user_id: user_id
      }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to eq({ "user_id" => user_id, "name" => cached_name })
    end
  end
end
