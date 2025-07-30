module Shared
    module Domain
      module Bus
        class CommandBus
          def execute(command)
             raise NotImplementedError, "#{self.class} must implement #execute"
          end
        end
      end
    end
end
