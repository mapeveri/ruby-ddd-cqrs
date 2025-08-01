class Api::V1::Message::GetMessagesController < ApplicationController
  def initialize(query_bus: Container[:query_bus])
    @query_bus = query_bus
    super()
  end

  def call
    chat_id = params[:chat_id]

    query = Chat::Application::Message::Queries::GetMessagesQuery.new(
      chat_id: chat_id,
    )

    result = @query_bus.ask(query)
    render json: result.content, status: :ok
  end
end
