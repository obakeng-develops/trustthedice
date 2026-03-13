class TeamsController < ApplicationController
  def create
    game = Game.find(params[:id])
    game.teams.create!(team_params)

    GameBroadcaster.broadcast(game)
    redirect_to host_game_path(game, token: game.host_token)
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
