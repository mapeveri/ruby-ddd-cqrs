require 'rails_helper'

RSpec.describe "POST /api/v1/users/join", type: :request do
  let(:user_id) { SecureRandom.uuid }

  before do
    $redis.del("user:#{user_id}")
  end

  describe "Given a user wants to join a chat" do
    it "returns a user_id and a name" do
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

  describe "Given a user is already log-in and want to join a chat" do
    before do
      data = { user_id: user_id, name: "Guest_#{rand(1000)}" }
      $redis.set("user:#{user_id}", data.to_json)
    end

    after do
      $redis.del("user:#{user_id}")
    end

    it "returns a user_id and a name from the cache" do
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
end
