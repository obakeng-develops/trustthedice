class TurnsController < ApplicationController
  def create
    game = Game.find(params[:id])
    round = game.rounds.order(number: :desc).first
    return redirect_to host_game_path(game, token: game.host_token) unless round

    team = game.teams.find(params[:turn][:team_id])
    rep_id = round.reps[team.id.to_s]

    round.turns.create!(team: team, rep_id: rep_id, topic: "pending", difficulty: "pending")
    redirect_to host_game_path(game, token: game.host_token)
  end
end
