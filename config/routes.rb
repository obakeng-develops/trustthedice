Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "games#new"

  resources :games, only: [ :create ] do
    member do
      get :join
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
      patch :roll_topic
      patch :roll_difficulty
      patch :roll_chaos
      patch :set_chaos_effect
      patch :swap_difficulty
      patch :set_lifeline
      patch :toggle_multiplier
      patch :assign_question
      patch :start_timer
      patch :mark_correct
      patch :mark_incorrect
      patch :award_steal
      patch :open_steal
      patch :close_steal
    end
  end
end
