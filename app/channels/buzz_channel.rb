class BuzzChannel < ApplicationCable::Channel
  def subscribed
    @game = Game.find_by(id: params[:game_id])
    reject unless @game
  end

  def buzz(data)
    player = Player.find_by(id: data["player_id"])
    turn = Turn.find_by(id: data["turn_id"])

    return unless player && turn
    return unless turn.round.game_id == @game.id
    return unless turn.steal_open?
    return if turn.steal_winner_player_id.present?

    turn.update!(
      steal_winner_team_id: player.team_id,
      steal_winner_player_id: player.id
    )

    GameBroadcaster.broadcast(@game)
  end
end
