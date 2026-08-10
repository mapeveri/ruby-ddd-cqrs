module Analytics
  module Infrastructure
    module Persistence
      module AnalyticsDb
        module ReadModels
          class SqlUserEngagementReadModel < Analytics::Application::Queries::GetUserEngagementReadModel
            def find_by_user_id(user_id:)
              records = MessageStateRecord.where("sender_id = :user_id OR receiver_id = :user_id", user_id: user_id.to_s)
              return nil unless records.exists?

              {
                "user_id" => user_id.to_s,
                "total_messages" => records.count,
                "chats_count" => chats(user_id.to_s).size,
                "last_message_at" => records.maximum(:created_at),
                "chats" => chats(user_id.to_s)
              }
            end

            private

            def chats(user_id)
              MessageStateRecord.where("sender_id = :user_id OR receiver_id = :user_id", user_id: user_id).distinct.pluck(:chat_id)
            end
          end
        end
      end
    end
  end
end
