class Container
  extend Dry::Container::Mixin

  register :message_repository do
    Chat::Infrastructure::Persistence::ActiveRecord::Repositories::ActiveRecordMessageRepository.new
  end

  register :get_messages_read_model do
    Chat::Infrastructure::Persistence::Redis::ReadModels::RedisGetMessagesReadModel.new
  end

  register :active_record_embedding_writer do
    Chat::Infrastructure::Persistence::ActiveRecord::Services::MessageEmbeddingWriter.new
  end

  register :event_bus do
    if Rails.env.test?
      Shared::Infrastructure::Bus::InMemoryEventBus.new
    else
      Shared::Infrastructure::Bus::RabbitMqEventBus.new
    end
  end

  register :query_bus do
    Shared::Infrastructure::Bus::InMemoryQueryBus.new .tap do |bus|
      bus.register(
        Chat::Application::Message::Queries::GetMessagesQuery,
        Chat::Application::Message::Queries::GetMessagesQueryHandler.new(
          get_messages_read_model: Container[:get_messages_read_model],
        )
      )
    end
  end

  register :command_bus do
    Shared::Infrastructure::Bus::InMemoryCommandBus.new .tap do |bus|
      bus.register(
        Chat::Application::Message::Commands::SendMessageCommand,
        Chat::Application::Message::Commands::SendMessageCommandHandler.new(
          message_repository: Container[:message_repository],
          event_bus: Container[:event_bus]
        )
      )
    end
  end
end
