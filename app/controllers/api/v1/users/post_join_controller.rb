class Api::V1::Users::PostJoinController < ApplicationController
  def call
    user_id = params[:user_id]
    session_data = $redis.get("user:#{user_id}")
    if session_data
      Rails.logger.info("Getting user #{user_id} from cache")
      data = JSON.parse(session_data)
      render json: data and return
    end

    name = "Guest_#{rand(1000)}"
    data = { user_id: user_id, name: name }
    Rails.logger.info("Setting user #{user_id}")
    $redis.setex("user:#{user_id}", 3600, data.to_json)

    render json: data
  end
end
