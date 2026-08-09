module Analytics
  module Infrastructure
    module Persistence
      module AnalyticsDb
        class ApplicationRecord < ActiveRecord::Base
          self.abstract_class = true

          establish_connection(ENV.fetch("ANALYTICS_DATABASE_URL"))
        end
      end
    end
  end
end
