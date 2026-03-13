class GamesController < ApplicationController
  before_action :set_game, only: [ :show, :join, :update_settings ]
  before_action :require_host_token, only: [ :show, :update_settings ]

  def new
  end

  def create
    game = Game.create!
    redirect_to host_game_path(game, token: game.host_token)
  end

  def show
    @teams = @game.teams.includes(:players)
    @round = @game.rounds.order(number: :desc).first
    @turn = @round&.turns&.order(created_at: :desc)&.first
  end

  def join
    @teams = @game.teams.order(:name)
    @round = @game.rounds.order(number: :desc).first
    @turn = @round&.turns&.order(created_at: :desc)&.first
  end

  def update_settings
    settings = @game.settings.merge(game_settings_params)
    @game.update!(settings: settings)
    GameBroadcaster.broadcast(@game)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: [] }
      format.html { redirect_to host_game_path(@game, token: @game.host_token) }
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def require_host_token
    return if params[:token] == @game.host_token

    head :not_found
  end

  def game_settings_params
    permitted = params.require(:game).permit(:questions_per_rep)
    permitted[:questions_per_rep] = permitted[:questions_per_rep].to_i if permitted[:questions_per_rep]
    permitted
  end
end
