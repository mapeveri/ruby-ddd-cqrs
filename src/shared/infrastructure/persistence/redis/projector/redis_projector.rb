class Shared::Infrastructure::Persistence::Redis::Projector::RedisProjector
  class << self
    def store(key:, value:, index_field:)
      index_key = "#{key}:index"
      field_value = value[index_field] || value[index_field.to_sym]
      position_index = $redis.hget(index_key, field_value)&.to_i

      if position_index
        Rails.logger.info("[RedisProjector] -> Updating #{key}")
        current_value = JSON.parse($redis.lindex(key, position_index))
        updated_value = safe_merge(current_value, value)
        $redis.lset(key, position_index, updated_value.to_json)
        return
      end

      Rails.logger.info("[RedisProjector] -> Inserting #{key}")
      position_index = $redis.rpush(key, value.to_json).to_i - 1
      $redis.hset(index_key, field_value, position_index)
    end

    def fetch(key:, limit: 50)
      raw = $redis.lrange(key, -limit, -1)
      raw.map { |msg| JSON.parse(msg) }
    end

    private
      def safe_merge(original, updates)
        updates.each do |key, value|
          string_key = key.to_s
          original[string_key] = value unless value.nil?
        end
        original
      end
  end
end
