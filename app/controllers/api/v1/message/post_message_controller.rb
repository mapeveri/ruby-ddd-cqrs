class Api::V1::Message::PostMessageController < ApplicationController
  def initialize(command_bus: Container[:command_bus])
    @command_bus = command_bus
    super()
  end

  def call
    command = Chat::Application::Message::Commands::SendMessageCommand.new(
      id: params[:id],
      sender_id: params[:sender_id],
      receiver_id: params[:receiver_id],
      content: params[:content]
    )

    @command_bus.execute(command)
    render json: {}, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
