class MessageRecord < ApplicationRecord
  validates :id, presence: true, uniqueness: true
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :content, presence: true, length: { maximum: Chat::Domain::Message::MessageContent::MAX_LENGTH }
  validates :created_at, presence: true
end
