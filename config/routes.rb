Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :messages do
        post "/", to: "post_messages#call"
        get "/:chat_id", to: "get_messages#call"
        get "/search/:chat_id", to: "get_search_messages#call"
      end
      namespace :users do
        post "/join", to: "post_join#call"
        get "/online_users", to: "online_users#call"
      end
    end
  end

  scope "/api/v1/analytics", module: "analytics/infrastructure/controllers" do
    get "/chat_activity/:chat_id", to: "get_chat_activity#call"
    get "/user_engagement/:user_id", to: "get_user_engagement#call"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount ActionCable.server => "/cable"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
