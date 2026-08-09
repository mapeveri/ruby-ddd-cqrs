class Analytics::Infrastructure::Persistence::Redis::Projector::ChatActivityProjector
  PREFIX = "analytics:chat_activity"

  def project_message_sent(event)
    key = "#{PREFIX}:#{event.chat_id}"
    participants_key = "#{key}:participants"
    timestamp = event.created_at.to_s

    $redis.sadd(participants_key, event.sender_id.to_s)
    $redis.sadd(participants_key, event.receiver_id.to_s)
    participants_count = $redis.scard(participants_key)

    $redis.multi do |multi|
      multi.hincrby(key, "message_count", 1)
      multi.hsetnx(key, "first_message_at", timestamp)
      multi.hset(key, "last_message_at", timestamp)
      multi.hset(key, "unique_participants", participants_count)
    end
  end

  def fetch_chat_activity(chat_id:)
    key = "#{PREFIX}:#{chat_id}"
    attrs = $redis.hgetall(key)
    return nil if attrs.empty?

    attrs["chat_id"] = chat_id.to_s
    attrs["participants"] = $redis.smembers("#{key}:participants")
    attrs
  end

  def snapshot_state
    keys = $redis.keys("#{PREFIX}:*").reject { |k| k.end_with?(":participants") }
    keys.each_with_object({}) do |key, state|
      chat_id = key.delete_prefix("#{PREFIX}:")
      state[chat_id] = $redis.hgetall(key).merge(
        "participants" => $redis.smembers("#{key}:participants")
      )
    end
  end

  def restore(state)
    state.each do |chat_id, attrs|
      key = "#{PREFIX}:#{chat_id}"
      participants = attrs.delete("participants")
      $redis.hset(key, attrs)
      $redis.sadd("#{key}:participants", *participants) unless participants.nil? || participants.empty?
    end
  end
end
