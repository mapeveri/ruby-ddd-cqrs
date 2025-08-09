require "redis"

$redis = Redis.new(url: ENV["REDIS_URL"])

begin
  Rails.logger.warn("🧪 Redis initializer running in #{Rails.env}")

  existing_indexes = $redis.call("FT._LIST")
  unless existing_indexes.include?("chat_messages_idx")
    $redis.call(
      "FT.CREATE", "chat_messages_idx",
      "ON", "HASH",
      "PREFIX", "1", "chat:message:",
      "SCHEMA",
      "id", "TEXT",
      "chat_id", "TAG",
      "content", "TEXT",
      "embedding", "VECTOR", "FLAT", "6",
      "TYPE", "FLOAT32",
      "DIM", "3072",
      "DISTANCE_METRIC", "COSINE"
    )
    Rails.logger.info("✅ Redis vector index created")
  end
rescue => e
  Rails.logger.warn("⚠️ Could not create Redis vector index: #{e.message}")
end
