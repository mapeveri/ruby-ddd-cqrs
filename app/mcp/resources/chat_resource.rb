# frozen_string_literal: true

module MCP
  class ChatResource < ApplicationResource
    uri "file:///chats/{chat_id}/messages"
    resource_name "ChatResource"
    description "Messages belonging to a specific chat"
    mime_type "application/json"

    def initialize(*args, **kwargs)
      @query_bus = Container[:query_bus]
      super(*args, **kwargs)
    end

    def content
      chat_id = params[:chat_id]
      query = Chat::Application::Message::Queries::GetMessagesQuery.new(
        chat_id: chat_id
      )

      result = @query_bus.ask(query)

      JSON.generate(result.as_json)
    end
  end
end
