class Container
  extend Dry::Container::Mixin

  register :command_bus do
    Shared::Infrastructure::Bus::InMemoryCommandBus.new .tap do |bus|
      bus.register(
        Chat::Application::Message::Commands::SendMessageCommand,
        Chat::Application::Message::Commands::SendMessageCommandHandler
      )
    end
  end
end

Container = Dry::AutoInject Container
