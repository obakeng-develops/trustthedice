class TeamsController < ApplicationController
  def create
    game = Game.find(params[:id])
    game.teams.create!(team_params)
    GameBroadcaster.broadcast(game)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: [] }
      format.html { redirect_to host_game_path(game, token: game.host_token) }
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
