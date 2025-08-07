module EventSubscriptions
  def self.registry
    {
      Chat::Domain::Message::MessageSent => [
        Chat::Infrastructure::Subscribers::Message::Projection::AddMessageProjectionSubscriber.new,
        Chat::Infrastructure::Subscribers::Message::Ws::BroadcastMessageSentSubscriber.new,
        Chat::Infrastructure::Subscribers::Message::Ai::ProcessMessageEmbeddingSubscriber.new(
          active_record_embedding_writer: Container[:active_record_embedding_writer]
        )
      ]
    }
  end
end
