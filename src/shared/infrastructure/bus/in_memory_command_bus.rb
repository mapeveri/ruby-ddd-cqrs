module Shared
  module Infrastructure
    module Bus
      class InMemoryCommandBus < Shared::Domain::Bus::CommandBus
        def initialize
          @handlers = {}
        end

        def register(command_class, handler_class)
          @handlers[command_class] = handler_class
        end

        def execute(command)
          handler = @handlers[command.class]
          raise "No handler registered for #{command.class}" unless handler

          handler.call(command)
        end
      end
    end
  end
end
