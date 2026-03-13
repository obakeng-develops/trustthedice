class GameBroadcaster
  def self.broadcast(game, focus_dice: false)
    Turbo::StreamsChannel.broadcast_replace_to(
      "game_#{game.id}",
      target: "host-state",
      partial: "games/host_state",
      locals: { game: game, focus_dice: focus_dice }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      "game_#{game.id}",
      target: "player-state",
      partial: "games/player_state",
      locals: { game: game }
    )
  end
end
