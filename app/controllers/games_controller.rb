class GamesController < ApplicationController
  before_action :set_game, only: [ :show, :join ]
  before_action :require_host_token, only: [ :show ]

  def new
  end

  def create
    game = Game.create!
    redirect_to host_game_path(game, token: game.host_token)
  end

  def show
    @teams = @game.teams.includes(:players)
    @round = @game.rounds.order(number: :desc).first
  end

  def join
    @teams = @game.teams.order(:name)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def require_host_token
    return if params[:token] == @game.host_token

    head :not_found
  end
end
