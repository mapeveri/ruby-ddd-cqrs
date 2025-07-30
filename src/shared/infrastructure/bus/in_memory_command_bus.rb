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
          handler_class = @handlers[command.class]
          raise "No handler registered for #{command.class}" unless handler_class

          handler = handler_class.new
          handler.call(command)
        end
      end
    end
  end
end
