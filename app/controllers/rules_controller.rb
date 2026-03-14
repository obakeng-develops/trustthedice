class RulesController < ApplicationController
  def show
    @game = Game.find_by(id: params[:game_id]) if params[:game_id].present?
  end
end
