require 'unit_helper'

RSpec.describe Analytics::Infrastructure::Persistence::Redis::Projector::ChatActivityProjector do
  let(:projector) { described_class.new }
  let(:chat_id) { SecureRandom.uuid }
  let(:sender_id) { SecureRandom.uuid }
  let(:receiver_id) { SecureRandom.uuid }
  let(:other_sender) { SecureRandom.uuid }

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
    it 'stores message count, participants and first/last activity' do
      projector.project_message_sent(message_sent)
      projector.project_message_sent(message_sent(sender_id: other_sender, created_at: Time.now + 10))

      activity = projector.fetch_chat_activity(chat_id: chat_id)

      expect(activity["chat_id"]).to eq(chat_id)
      expect(activity["message_count"]).to eq("2")
      expect(activity["unique_participants"]).to eq("3")
      expect(activity["participants"]).to contain_exactly(sender_id, receiver_id, other_sender)
      expect(activity["first_message_at"]).not_to be_nil
      expect(activity["last_message_at"]).not_to be_nil
    end

    it 'does not duplicate participants' do
      2.times { projector.project_message_sent(message_sent) }

      activity = projector.fetch_chat_activity(chat_id: chat_id)

      expect(activity["message_count"]).to eq("2")
      expect(activity["unique_participants"]).to eq("2")
      expect(activity["participants"]).to contain_exactly(sender_id, receiver_id)
    end
  end

  describe '#fetch_chat_activity' do
    it 'returns nil for a chat without activity' do
      expect(projector.fetch_chat_activity(chat_id: SecureRandom.uuid)).to be_nil
    end
  end

  describe '#snapshot_state and #restore' do
    it 'restores the projection from a snapshot' do
      projector.project_message_sent(message_sent)
      projector.project_message_sent(message_sent(sender_id: other_sender))

      state = projector.snapshot_state
      $redis.del(*$redis.keys("analytics:*"))

      projector.restore(state)

      activity = projector.fetch_chat_activity(chat_id: chat_id)
      expect(activity["message_count"]).to eq("2")
      expect(activity["unique_participants"]).to eq("3")
      expect(activity["participants"]).to contain_exactly(sender_id, receiver_id, other_sender)
    end

    it 'captures every chat with activity' do
      other_chat = SecureRandom.uuid
      projector.project_message_sent(message_sent)
      projector.project_message_sent(message_sent(chat_id: other_chat))

      state = projector.snapshot_state

      expect(state.keys).to contain_exactly(chat_id, other_chat)
      expect(state[chat_id]["message_count"]).to eq("1")
      expect(state[other_chat]["message_count"]).to eq("1")
    end
  end
end
