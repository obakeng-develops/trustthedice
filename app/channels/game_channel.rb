class GameChannel < ApplicationCable::Channel
  def subscribed
    game = Game.find_by(id: params[:game_id])
    return reject unless game

    stream_from "game_#{game.id}"
  end
end
