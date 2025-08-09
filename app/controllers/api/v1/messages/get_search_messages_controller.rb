class Api::V1::Messages::GetSearchMessagesController < ApplicationController
  def initialize(query_bus: Container[:query_bus])
    @query_bus = query_bus
    super()
  end

  def call
    chat_id = params[:chat_id]
    text = params[:q]

    query = Chat::Application::Message::Queries::Search::SearchMessagesQuery.new(
      chat_id: chat_id,
      text: text
    )

    result = @query_bus.ask(query)
    render json: result.content.messages, status: :ok
  end
end
