require 'unit_helper'

RSpec.describe Analytics::Infrastructure::Persistence::Redis::Projector::UserEngagementProjector do
  let(:projector) { described_class.new }
  let(:chat_id) { SecureRandom.uuid }
  let(:other_chat) { SecureRandom.uuid }
  let(:sender_id) { SecureRandom.uuid }
  let(:receiver_id) { SecureRandom.uuid }

  def message_sent(overrides = {})
    Chat::Domain::Message::MessageSent.new(**{
      id: SecureRandom.uuid,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: "hello",
      chat_id: chat_id,
      created_at: Time.now
    }.merge(overrides))
  end

  describe '#project_message_sent' do
    it 'counts messages sent and tracks participating chats' do
      projector.project_message_sent(message_sent)
      projector.project_message_sent(message_sent(chat_id: other_chat))

      engagement = projector.fetch_user_engagement(user_id: sender_id)

      expect(engagement["user_id"]).to eq(sender_id)
      expect(engagement["total_messages"]).to eq("2")
      expect(engagement["chats_count"]).to eq("2")
      expect(engagement["chats"]).to contain_exactly(chat_id, other_chat)
      expect(engagement["last_message_at"]).not_to be_nil
    end

    it 'tracks chats for the receiver without counting received messages' do
      projector.project_message_sent(message_sent)

      receiver_engagement = projector.fetch_user_engagement(user_id: receiver_id)

      expect(receiver_engagement["chats"]).to contain_exactly(chat_id)
      expect(receiver_engagement).not_to have_key("total_messages")
    end
  end

  describe '#fetch_user_engagement' do
    it 'returns nil for a user without engagement' do
      expect(projector.fetch_user_engagement(user_id: SecureRandom.uuid)).to be_nil
    end
  end

  describe '#snapshot_state and #restore' do
    it 'restores the projection from a snapshot' do
      projector.project_message_sent(message_sent)
      projector.project_message_sent(message_sent(chat_id: other_chat))

      state = projector.snapshot_state
      $redis.del(*$redis.keys("analytics:*"))

      projector.restore(state)

      engagement = projector.fetch_user_engagement(user_id: sender_id)
      expect(engagement["total_messages"]).to eq("2")
      expect(engagement["chats"]).to contain_exactly(chat_id, other_chat)
    end

    it 'captures every user with engagement' do
      projector.project_message_sent(message_sent)

      state = projector.snapshot_state

      expect(state.keys).to contain_exactly(sender_id, receiver_id)
      expect(state[sender_id]["total_messages"]).to eq("1")
      expect(state[receiver_id]).not_to have_key("total_messages")
    end
  end
end
