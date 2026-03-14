class LeaderboardsController < ApplicationController
  before_action :set_game
  before_action :require_host_token

  def show
    @teams = @game.teams.order(score: :desc, name: :asc)
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
