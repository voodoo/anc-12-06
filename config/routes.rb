Rails.application.routes.draw do
  root "posts#index"

  resources :posts do
    resources :votes, only: [:create, :destroy]
    resources :comments, only: [:create]
  end
  
  resource :session
  resources :passwords, param: :token
  get "map", to: "home#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
