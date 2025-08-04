require 'rails_helper'

RSpec.describe "POST /api/v1/users/join", type: :request do
  describe "Given a user wants to join a chat" do
    it "returns a token and a name" do
      post "/api/v1/users/join"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to have_key("token")
      expect(json).to have_key("name")
      expect(json["name"]).to match(/^Guest_/)
    end
  end
end
