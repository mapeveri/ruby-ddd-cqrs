module Analytics
  module Infrastructure
    module Persistence
      module AnalyticsDb
        module ReadModels
          class SqlChatActivityReadModel < Analytics::Application::Queries::GetChatActivityReadModel
            def find_by_chat_id(chat_id:)
              records = MessageStateRecord.where(chat_id: chat_id.to_s)
              return nil unless records.exists?

              {
                "chat_id" => chat_id.to_s,
                "message_count" => records.count,
                "unique_participants" => participants(chat_id.to_s).size,
                "first_message_at" => records.minimum(:created_at),
                "last_message_at" => records.maximum(:created_at),
                "participants" => participants(chat_id.to_s)
              }
            end

            private

            def participants(chat_id)
              senders = MessageStateRecord.where(chat_id: chat_id).distinct.pluck(:sender_id)
              receivers = MessageStateRecord.where(chat_id: chat_id).distinct.pluck(:receiver_id)
              (senders + receivers).uniq
            end
          end
        end
      end
    end
  end
end
