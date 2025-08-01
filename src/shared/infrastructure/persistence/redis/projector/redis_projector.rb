class Shared::Infrastructure::Persistence::Redis::Projector::RedisProjector
  class << self
    def store(key:, value:)
      $redis.rpush(key, value.to_json)
    end

    def fetch(key:, limit: 50)
      raw = $redis.lrange(key, -limit, -1)
      raw.map { |msg| JSON.parse(msg) }
    end
  end
end
