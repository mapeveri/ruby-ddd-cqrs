require 'dry/auto_inject'

class Container
  extend Dry::Container::Mixin

  # register :user_repository do
  #  Chat::Infrastructure::Persistence::Repositories::ActiveRecordUserRepository.new
  # end

  register :message_repository do
    Chat::Infrastructure::Persistence::Repositories::ActiveRecordMessageRepository.new
  end
  
  register :command_bus do
    Shared::Infrastructure::Bus::InMemoryCommandBus.new .tap do |bus|
      bus.register(
        Chat::Application::Message::Commands::SendMessageCommand,
        Chat::Application::Message::Commands::SendMessageCommandHandler.new(
          message_repository: Container[:message_repository]
        )
      )
    end
  end
end

module DI
  Import = Dry::AutoInject(Container)
end