class Api::V1::Users::OnlineUsersController < ApplicationController
  def call
    cursor = 0
    users = []

    loop do
      cursor, keys = $redis.scan(cursor, match: "session:*", count: 100)
      keys.each do |k|
        data = $redis.get(k)
        users << JSON.parse(data) if data
      end
      break if cursor == "0"
    end

    render json: users
  end
end
