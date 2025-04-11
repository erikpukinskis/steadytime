require "googleauth"
require "net/http"
require "json"

class AuthController < ApplicationController
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
    end

    # If you need to exchange the ID token for an access token
    # (Only needed for accessing Google APIs)
    access_token_response = GoogleAuthService.exchange_id_token_for_access_token(params[:credential])

    if !access_token_response
      render json: { error: "Could not exchange ID token for access token" }, status: :unauthorized
    end


    # Store user info and tokens
    session[:user_email] = payload["email"]
    session[:user_name] = payload["name"]
    session[:user_given_name] = payload["given_name"]
    session[:access_token] = access_token_response["access_token"]

    render json: {
      id_token_payload: payload,
      access_token_response: access_token_response
    }
  end
end
