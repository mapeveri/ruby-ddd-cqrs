module Analytics
  module Infrastructure
    module Persistence
      module AnalyticsDb
        class MessageRecord < ApplicationRecord
          self.table_name = "message_records"
        end
      end
    end
  end
end
