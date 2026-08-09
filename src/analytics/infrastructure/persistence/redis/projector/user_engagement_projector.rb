class Analytics::Infrastructure::Persistence::Redis::Projector::UserEngagementProjector
  PREFIX = "analytics:user_engagement"

  def project_message_sent(event)
    timestamp = event.created_at.to_s
    sender_key = "#{PREFIX}:#{event.sender_id}"
    receiver_key = "#{PREFIX}:#{event.receiver_id}"

    $redis.sadd("#{sender_key}:chats", event.chat_id.to_s)
    $redis.sadd("#{receiver_key}:chats", event.chat_id.to_s)
    sender_chats = $redis.scard("#{sender_key}:chats")
    receiver_chats = $redis.scard("#{receiver_key}:chats")

    $redis.multi do |multi|
      multi.hincrby(sender_key, "total_messages", 1)
      multi.hset(sender_key, "last_message_at", timestamp)
      multi.hset(sender_key, "chats_count", sender_chats)
      multi.hset(receiver_key, "chats_count", receiver_chats)
    end
  end

  def fetch_user_engagement(user_id:)
    key = "#{PREFIX}:#{user_id}"
    attrs = $redis.hgetall(key)
    return nil if attrs.empty?

    attrs["user_id"] = user_id.to_s
    attrs["chats"] = $redis.smembers("#{key}:chats")
    attrs
  end

  def snapshot_state
    keys = $redis.keys("#{PREFIX}:*").reject { |k| k.end_with?(":chats") }
    keys.each_with_object({}) do |key, state|
      user_id = key.delete_prefix("#{PREFIX}:")
      state[user_id] = $redis.hgetall(key).merge(
        "chats" => $redis.smembers("#{key}:chats")
      )
    end
  end

  def restore(state)
    state.each do |user_id, attrs|
      key = "#{PREFIX}:#{user_id}"
      chats = attrs.delete("chats")
      $redis.hset(key, attrs)
      $redis.sadd("#{key}:chats", *chats) unless chats.nil? || chats.empty?
    end
  end
end
