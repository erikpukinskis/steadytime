require "googleauth"
require "net/http"
require "json"

class AuthController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /auth/sign_in
  #
  # Renders the sign in page
  def sign_in
    @GOOGLE_CLIENT_ID = ENV["GOOGLE_CLIENT_ID"]
  end

  # POST /auth/google_oauth2/callback
  #
  # Handles the callback from Google Sign-In after successful authentication. Google
  # sends a POST request to this endpoint containing the user's credentials.
  #
  # @actionparam :credential [String]The JWT ID token containing user information.
  # @actionparam :g_csrf_token [String] A CSRF token provided by Google.
  # @actionparam :authenticity_token Rails CSRF token.
  #
  # @response [JSON] The params received in the callback.
  def google_oauth2_callback
    # Store the credential (ID token) in the session
    session[:google_oauth2_credential] = params[:credential]

    # Verify and decode the ID token
    payload = GoogleAuthService.verify_id_token(params[:credential])

    if !payload
      render json: { error: "Invalid ID token" }, status: :unauthorized
      return
    end

    # If you need to exchange the ID token for an access token
    # (Only needed for accessing Google APIs)
    access_token_response = GoogleAuthService.exchange_id_token_for_access_token(params[:credential])

    if !access_token_response
      render json: { error: "Could not exchange ID token for access token" }, status: :unauthorized
      return
    end

    ActiveRecord::Base.transaction do
      user = User.create!(
        nickname: payload["given_name"] || payload["name"]
      )

      google_account = GoogleAccount.create!(
        id: payload["sub"],
        email: payload["email"],
        name: payload["name"],
        given_name: payload["given_name"],
        picture_url: payload["picture"],
        user: user
      )

      # Store session data
      session[:user_id] = google_account.user.id
      session[:user_nickname] = google_account.user.nickname
      session[:google_oauth2_access_token] = access_token_response["access_token"]
    end

    # Redirect to the stored return_to URL or fall back to root_path
    redirect_to(session.delete(:return_to) || root_path)
  end
end
