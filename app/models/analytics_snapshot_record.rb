class AnalyticsSnapshotRecord < ApplicationRecord
  validates :projection_key, presence: true, uniqueness: true
end
