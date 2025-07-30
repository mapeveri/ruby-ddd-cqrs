class V1::Message::PostMessageController < ApplicationController
  def call
    render json: {}, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
