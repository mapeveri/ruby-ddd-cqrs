module Analytics
  module Infrastructure
    module Persistence
      module ActiveRecord
        class AnalyticsSnapshotRecord < ApplicationRecord
          validates :projection_key, presence: true, uniqueness: true
        end
      end
    end
  end
end
