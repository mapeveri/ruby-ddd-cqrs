require 'ostruct'

module Shared
  module Infrastructure
    module Bus
      class InMemoryQueryBus < Shared::Domain::Bus::QueryBus
        def initialize
          @handlers = {}
        end

        def register(query_class, handler_class)
          @handlers[query_class] = handler_class
        end

        def ask(query)
          handler = @handlers[query.class]
          raise "No handler registered for #{query.class}" unless handler

          result = handler.call(query)

          OpenStruct.new(content: result)
        end
      end
    end
  end
end
