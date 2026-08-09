class Api::V1::Analytics::GetUserEngagementController < ApplicationController
  def initialize(query_bus: Container[:query_bus])
    @query_bus = query_bus
    super()
  end

  def call
    user_id = params[:user_id]

    query = Analytics::Application::Queries::GetUserEngagementQuery.new(
      user_id: user_id
    )

    result = @query_bus.ask(query)
    render json: result.content.engagement, status: :ok
  end
end
