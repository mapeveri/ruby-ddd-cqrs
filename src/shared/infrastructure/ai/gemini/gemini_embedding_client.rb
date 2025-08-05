require "net/http"
require "json"
require "uri"

class Shared::Infrastructure::Ai::Gemini::GeminiEmbeddingClient
  def self.embed_text(text)
    base_url = ENV.fetch("GEMINI_API_BASE_URL")
    model = ENV.fetch("GEMINI_EMBEDDING_MODEL")
    uri = URI("#{base_url}/models/#{model}:embedContent")
    api_key = ENV.fetch("GEMINI_API_KEY")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["X-Goog-Api-Key"] = api_key

    request.body = {
      model: "models/#{model}",
      content: {
        parts: [
          { text: text }
        ]
      }
    }.to_json

    response = http.request(request)
    raise "Gemini API Error: #{response.code} #{response.body}" unless response.code == "200"

    result = JSON.parse(response.body)
    result.dig("embedding", "values")
  end
end

