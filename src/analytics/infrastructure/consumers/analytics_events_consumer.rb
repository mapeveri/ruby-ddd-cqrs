class Analytics::Infrastructure::Consumers::AnalyticsEventsConsumer
  def initialize(
    kafka_client:,
    topic:,
    group_id:,
    chat_activity_projector:,
    user_engagement_projector:,
    snapshot_manager:
  )
    @kafka_client = kafka_client
    @kafka = kafka_client.connection
    @topic = topic
    @group_id = group_id
    @chat_activity_projector = chat_activity_projector
    @user_engagement_projector = user_engagement_projector
    @snapshot_manager = snapshot_manager
  end

  def consume
    @kafka_client.ensure_topic(@topic)
    @consumer = @kafka.consumer(group_id: @group_id)
    @consumer.subscribe(@topic, start_from_beginning: true)

    restore_from_snapshots

    @consumer.each_message do |message|
      handle(message)
      @consumer.mark_message_as_processed(message)
    end
  end

  def handle(message)
    data = JSON.parse(message.value)
    event = Object.const_get(data["event_type"]).from_h(data)

    case event
    when Chat::Domain::Message::MessageSent
      project_message_sent(event, message)
    else
      Rails.logger.warn("[AnalyticsEventsConsumer] No projection for #{event.class}")
    end
  rescue => e
    Rails.logger.error("[AnalyticsEventsConsumer] Error processing message: #{e.message}")
  end

  private

    def restore_from_snapshots
      snapshot = @snapshot_manager.restore("chat_activity")
      @chat_activity_projector.restore(snapshot.state) if snapshot

      snapshot = @snapshot_manager.restore("user_engagement")
      @user_engagement_projector.restore(snapshot.state) if snapshot
    end

    def project_message_sent(event, message)
      @chat_activity_projector.project_message_sent(event)
      @user_engagement_projector.project_message_sent(event)

      @snapshot_manager.track(
        projection_key: "chat_activity",
        state: @chat_activity_projector.snapshot_state,
        kafka_offset: message.offset
      )
      @snapshot_manager.track(
        projection_key: "user_engagement",
        state: @user_engagement_projector.snapshot_state,
        kafka_offset: message.offset
      )
    end
end
