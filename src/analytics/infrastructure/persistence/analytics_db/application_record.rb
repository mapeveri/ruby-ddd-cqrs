module Analytics
  module Infrastructure
    module Persistence
      module AnalyticsDb
        class ApplicationRecord < ActiveRecord::Base
          self.abstract_class = true

          connects_to database: { writing: :analytics }
        end
      end
    end
  end
end
