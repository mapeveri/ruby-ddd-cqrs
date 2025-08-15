require "net/http"
require "json"
require "uri"

class Shared::Infrastructure::Ai::Gemini::GeminiLlmClient
  def generate_text(prompt)
    base_url = ENV.fetch("GEMINI_API_BASE_URL")
    model = ENV.fetch("GEMINI_LLM_MODEL")
    api_key = ENV.fetch("GEMINI_API_KEY")

    uri = URI("#{base_url}/models/#{model}:generateContent")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["X-Goog-Api-Key"] = api_key

    request.body = {
      contents: [
        {
          parts: [
            { text: prompt }
          ]
        }
      ]
    }.to_json

    response = http.request(request)
    raise "Gemini API Error: #{response.code} #{response.body}" unless response.code == "200"

    result = JSON.parse(response.body)
    result.dig("candidates", 0, "content", "parts", 0, "text")
  end
end
