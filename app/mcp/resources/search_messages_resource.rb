# frozen_string_literal: true

module MCP
  class SearchMessagesResource < ApplicationResource
    uri "chats/:chat_id/messages/search"
    resource_name "Messages"
    description "Search messages in chat"
    mime_type "application/json"

    arguments do
      required(:chat_id).filled(:string).description("Chat id to search")
      required(:text).filled(:string).description("Text to search")
    end

    def initialize(**kwargs)
      @query_bus = Container[:query_bus]
      super()
    end

    def content
      chat_id = params[:chat_id]
      query = params[:text]

      query = Chat::Application::Message::Queries::SearchMessagesQuery.new(
        chat_id: chat_id,
        text: text
      )

      result = @query_bus.ask(query)

      JSON.generate(result.content.response)
    end
  end
end
