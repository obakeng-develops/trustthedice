Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "games#new"

  get "rules", to: "rules#show", as: :rules
  get "leaderboard/:id/:token", to: "leaderboards#show", as: :leaderboard

  resources :games, only: [ :create ] do
    member do
      get :join
      patch :update_settings
      post :players, to: "players#create"
      post :teams, to: "teams#create"
      post :rounds, to: "rounds#create"
      post :turns, to: "turns#create"
    end
  end

  get "games/:id/host/:token", to: "games#show", as: :host_game

  resources :rounds, only: [ :update ]
  resources :turns, only: [] do
    member do
      post :buzz
      patch :update_manual
      patch :assign_question
      patch :mark_correct
      patch :mark_incorrect
      patch :open_steal
      patch :close_steal
      patch :award_steal
      patch :next_question
    end
  end
end
