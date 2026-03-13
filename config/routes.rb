Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "games#new"

  resources :games, only: [ :create ] do
    member do
      get :join
      post :players, to: "players#create"
      post :teams, to: "teams#create"
      post :rounds, to: "rounds#create"
    end
  end

  get "games/:id/host/:token", to: "games#show", as: :host_game

  resources :rounds, only: [ :update ]
end
