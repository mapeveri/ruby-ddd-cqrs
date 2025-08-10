class Chat::Infrastructure::Persistence::Redis::Services::RedisEmbedding
  MIN_SCORE = 0.4

  def store(id:, chat_id:, content:, embedding:)
    raise "Embedding incorrect dimension" unless embedding.size == 3072

    key = "chat:message:#{chat_id}:#{id}"
    embedding_blob = embedding.map(&:to_f).pack('e*').force_encoding(Encoding::BINARY)

    $redis.call(
      "HSET", key,
      "id", id,
      "chat_id", chat_id,
      "content", content,
      "embedding", embedding_blob
    )
  end

  def search(chat_id:, query_embedding:)
    raise "Query embedding incorrect dimension" unless query_embedding.size == 3072

    bin_query = query_embedding.map(&:to_f).pack('e*').force_encoding(Encoding::BINARY)
    escaped_chat_id = chat_id.gsub('-', '\-')

    raw = $redis.call(
      "FT.SEARCH", "chat_messages_idx",
      "(@chat_id:{#{escaped_chat_id}})=>[KNN 5 @embedding $vec AS score]",
      "PARAMS", 2, "vec", bin_query,
      "SORTBY", "score",
      "DIALECT", 2
    )

    return [] if raw.nil? || raw.empty? || raw[0].to_i.zero?

    results = self.parse_redis_search_result(raw)

    results.select { |result| MIN_SCORE >= result[:score].to_f }
  end

  private
    def parse_redis_search_result(raw)
      total = raw[0].to_i
      return [] if total.zero?

      results = []
      i = 1
      while i < raw.size
        doc_id = raw[i]
        fields = raw[i + 1]

        hash = Hash[*fields].transform_keys(&:to_sym)
        hash[:_id] = doc_id
        hash[:score] = hash[:score].to_f if hash.key?(:score)

        results << hash

        i += 2
      end

      results
    end
end
