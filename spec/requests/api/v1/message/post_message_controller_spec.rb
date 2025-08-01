require 'rails_helper'

RSpec.describe 'Given a PostMessageController', type: :request do
  describe 'POST /api/v1/message' do
    let(:id) { SecureRandom.uuid }
    let(:sender_id) { SecureRandom.uuid }
    let(:receiver_id) { SecureRandom.uuid }
    let(:chat_id) { SecureRandom.uuid }
    let(:content) { 'Hello, Bob!' }


    it 'creates a message and returns status created' do
      post '/api/v1/message', params: {
        id: id,
        sender_id: sender_id,
        receiver_id: receiver_id,
        content: content,
        chat_id: chat_id
      }

      expect(response).to have_http_status(:created)
    end
  end
end
