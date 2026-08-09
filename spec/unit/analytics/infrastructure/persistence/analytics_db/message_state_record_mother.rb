class MessageStateRecordMother
  def self.create(
    id: SecureRandom.uuid,
    chat_id: SecureRandom.uuid,
    sender_id: SecureRandom.uuid,
    receiver_id: SecureRandom.uuid,
    content: "hello",
    created_at: Time.now
  )
    Analytics::Infrastructure::Persistence::AnalyticsDb::MessageStateRecord.create!(
      id: id,
      chat_id: chat_id,
      sender_id: sender_id,
      receiver_id: receiver_id,
      content: content,
      created_at: created_at
    )
  end

  def self.random
    create
  end
end
