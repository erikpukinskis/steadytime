class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  private

  def authenticate_user!
    unless user_signed_in?
      session[:return_to] = request.fullpath
      redirect_to auth_sign_in_path
    end
  end

  def user_signed_in?
    session[:user_id].present?
  end

  helper_method :user_signed_in?
end
