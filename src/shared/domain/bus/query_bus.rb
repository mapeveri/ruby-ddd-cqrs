module Shared
  module Domain
    module Bus
      class QueryBus
        def ask(query)
          raise NotImplementedError, "#{self.class} must implement #query"
        end
      end
    end
  end
end
