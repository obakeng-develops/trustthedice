class GameBroadcaster
  def self.broadcast(game)
    Turbo::StreamsChannel.broadcast_replace_to(
      "game_#{game.id}",
      target: "host-state",
      partial: "games/host_state",
      locals: { game: game }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      "game_#{game.id}",
      target: "player-state",
      partial: "games/player_state",
      locals: { game: game }
    )
  end
end
