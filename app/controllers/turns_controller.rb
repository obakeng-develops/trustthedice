class TurnsController < ApplicationController
  def create
    game = Game.find(params[:id])
    round = game.current_round
    unless round
      redirect_to host_game_path(game, token: game.host_token)
      return
    end
    team = game.teams.find(params[:turn][:team_id])
    rep_id = round&.reps&.[](team.id.to_s)

    turn = round.turns.create!(team: team, rep_id: rep_id, topic: "pending", difficulty: "pending")

    GameBroadcaster.broadcast(game)
    redirect_to host_game_path(game, token: game.host_token)
  end

  def open_steal
    turn = Turn.find(params[:id])
    turn.update!(steal_open: true, steal_started_at: Time.current, steal_winner_team_id: nil, steal_winner_player_id: nil)

    GameBroadcaster.broadcast(turn.round.game)
    head :ok
  end

  def close_steal
    turn = Turn.find(params[:id])
    turn.update!(steal_open: false)

    GameBroadcaster.broadcast(turn.round.game)
    head :ok
  end
end
