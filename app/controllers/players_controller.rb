class PlayersController < ApplicationController
  def create
    game = Game.find(params[:id])
    team = game.teams.find(params[:player][:team_id])
    player = team.players.create!(player_params)

    session[:player_id] = player.id
    redirect_to join_game_path(game)
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
end
