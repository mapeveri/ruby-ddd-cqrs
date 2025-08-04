class Api::V1::Users::PostJoinController < ApplicationController
  def call
    token = SecureRandom.hex(16)
    name = "Guest_#{rand(1000)}"
    data = { token: token, name: name }
    $redis.setex("session:#{token}", 3600, data.to_json)

    render json: data
  end
end
