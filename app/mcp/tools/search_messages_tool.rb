# frozen_string_literal: true

module MCP
  class SearchMessagesTool < ApplicationTool
    tool_name "chat_search_messages"
    description "Search messages in chat"

    arguments do
      required(:chat_id).filled(:string).description("Chat id to search")
      required(:text).filled(:string).description("Text to search")
    end

    def initialize(**kwargs)
      @query_bus = Container[:query_bus]
      super()
    end

    def call(chat_id:, text:)
      query = Chat::Application::Message::Queries::SearchMessagesQuery.new(
        chat_id: chat_id,
        text: text
      )

      result = @query_bus.ask(query)

      result.content.response
    end
  end
end
