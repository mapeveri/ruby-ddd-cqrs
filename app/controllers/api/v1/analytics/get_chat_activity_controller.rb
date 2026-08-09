class Api::V1::Analytics::GetChatActivityController < ApplicationController
  def initialize(query_bus: Container[:query_bus])
    @query_bus = query_bus
    super()
  end

  def call
    chat_id = params[:chat_id]

    query = Analytics::Application::Queries::GetChatActivityQuery.new(
      chat_id: chat_id
    )

    result = @query_bus.ask(query)
    render json: result.content.activity, status: :ok
  end
end
