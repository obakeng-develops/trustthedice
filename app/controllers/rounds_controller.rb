class RoundsController < ApplicationController
  def create
    game = Game.find(params[:id])
    number = game.rounds.maximum(:number).to_i + 1
    game.rounds.create!(number: number)
    game.update!(status: "round_setup")
    GameBroadcaster.broadcast(game)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: [] }
      format.html { redirect_to host_game_path(game, token: game.host_token) }
    end
  end

  def update
    round = Round.find(params[:id])
    round.update!(round_params)
    round.game.update!(status: "question")
    GameBroadcaster.broadcast(round.game)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: [] }
      format.html { redirect_to host_game_path(round.game, token: round.game.host_token) }
    end
  end

  private

  def round_params
    params.require(:round).permit(reps: {})
  end
end
