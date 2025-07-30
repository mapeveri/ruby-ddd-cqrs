class V1::Message::PostMessageController < ApplicationController
  def call
    command = Chat::Application::Message::Commands::SendMessageCommand.new(
      id: params[:id],
      sender_id: params[:sender_id],
      receiver_id: params[:receiver_id],
      content: params[:content]
    )

    Container[:command_bus].call(command)
    render json: {}, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
