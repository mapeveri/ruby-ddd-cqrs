class Container
  extend Dry::Container::Mixin

  register :redis_chat_messages_projector do
    Chat::Infrastructure::Persistence::Redis::Projector::RedisChatMessagesProjector.new
  end

  register :kafka_client do
    Shared::Infrastructure::Messaging::Kafka::KafkaClient.new
  end

  register :message_state_producer do
    Shared::Infrastructure::Messaging::Kafka::KafkaProducer.new(
      kafka_client: Container[:kafka_client],
      topic: ENV.fetch("KAFKA_MESSAGE_STATE_TOPIC"),
      cleanup_policy: "compact"
    )
  end

  register :message_state_publisher do
    Chat::Infrastructure::Messaging::Kafka::MessageStatePublisher.new(
      kafka_producer: Container[:message_state_producer],
      enabled: !Rails.env.test?
    )
  end

  register :redis_embedding do
    Chat::Infrastructure::Persistence::Redis::Services::RedisEmbedding.new
  end

  register :gemini_embedding_client do
    Shared::Infrastructure::Ai::Gemini::GeminiEmbeddingClient.new
  end

  register :gemini_llm_client do
    Shared::Infrastructure::Ai::Gemini::GeminiLlmClient.new
  end

  register :message_repository do
    Chat::Infrastructure::Persistence::ActiveRecord::Repositories::ActiveRecordMessageRepository.new
  end

  register :get_messages_read_model do
    Chat::Infrastructure::Persistence::Redis::ReadModels::RedisGetMessagesReadModel.new(
      redis_chat_messages_projector: Container[:redis_chat_messages_projector]
    )
  end

  register :search_messages_read_model do
    Chat::Infrastructure::Persistence::Redis::ReadModels::RedisSearchMessagesReadModel.new(
      redis_embedding: Container[:redis_embedding],
      gemini_embedding_client: Container[:gemini_embedding_client],
      gemini_llm_client: Container[:gemini_llm_client]
    )
  end

  register :sql_chat_activity_read_model do
    Analytics::Infrastructure::Persistence::AnalyticsDb::ReadModels::SqlChatActivityReadModel.new
  end

  register :sql_user_engagement_read_model do
    Analytics::Infrastructure::Persistence::AnalyticsDb::ReadModels::SqlUserEngagementReadModel.new
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
      bus.register(
        Chat::Application::Message::Queries::SearchMessagesQuery,
        Chat::Application::Message::Queries::SearchMessagesQueryHandler.new(
          search_messages_read_model: Container[:search_messages_read_model],
        )
      )
      bus.register(
        Analytics::Application::Queries::GetChatActivityQuery,
        Analytics::Application::Queries::GetChatActivityQueryHandler.new(
          read_model: Container[:sql_chat_activity_read_model],
        )
      )
      bus.register(
        Analytics::Application::Queries::GetUserEngagementQuery,
        Analytics::Application::Queries::GetUserEngagementQueryHandler.new(
          read_model: Container[:sql_user_engagement_read_model],
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
