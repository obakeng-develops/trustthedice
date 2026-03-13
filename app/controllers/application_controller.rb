class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_player

  private

  def current_player
    return unless session[:player_id]

    @current_player ||= Player.find_by(id: session[:player_id])
  end
end
