class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_player
  helper_method :host_link, :on_host_page?

  private

  def current_player
    return unless session[:player_id]

    @current_player ||= Player.find_by(id: session[:player_id])
  end

  def host_link
    return unless session[:host_game_id] && session[:host_token]

    host_game_path(session[:host_game_id], token: session[:host_token])
  end

  def on_host_page?
    controller_name == "games" && action_name == "show" && params[:token].present?
  end
end
