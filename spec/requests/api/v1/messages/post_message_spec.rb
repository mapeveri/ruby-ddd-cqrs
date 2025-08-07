require 'rails_helper'

RSpec.describe 'Given a user that send a message', type: :request do
  describe 'When the url is POST /api/v1/messages' do
    let(:id) { SecureRandom.uuid }
    let(:sender_id) { SecureRandom.uuid }
    let(:receiver_id) { SecureRandom.uuid }
    let(:chat_id) { SecureRandom.uuid }
    let(:content) { 'Hello, Bob!' }

    it 'should create a message and return status created' do
      post '/api/v1/messages', params: {
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
