class Api::V1::Users::PostJoinController < ApplicationController
  def call
    token = SecureRandom.hex(16)
    name = "Guest_#{rand(1000)}"
    $redis.setex("session:#{token}", 3600, name)

    render json: { token: token, name: name }
  end
end
