class Api::V1::Messages::PostMessagesController < ApplicationController
  def initialize(command_bus: Container[:command_bus])
    @command_bus = command_bus
    super()
  end

  def call
    command = Chat::Application::Message::Commands::SendMessageCommand.new(
      id: params[:id],
      sender_id: params[:sender_id],
      receiver_id: params[:receiver_id],
      content: params[:content],
      chat_id: params[:chat_id]
    )

    @command_bus.execute(command)
    render json: {}, status: :created
  rescue StandardError => e
    Rails.logger.error("[PostMessagesController] -> error: #{e}")
    render json: { error: "There was an error" }, status: :unprocessable_entity
  end
end
