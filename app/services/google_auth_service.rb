# Service class for Google authentication operations
class GoogleAuthService
  # Verifies a Google ID token and returns the payload if valid
  #
  # @param id_token [String] The JWT ID token containing user information
  # @return [Hash, nil] The decoded token payload or nil if invalid
  #
  # @example Payload structure:
  #   {
  #     "iss": "[url of issuer e.g. https://accounts.google.com]",
  #     "azp": "[authorized party i.e. our GOOGLE_CLIENT_ID]",
  #     "aud": "[audience i.e. our GOOGLE_CLIENT_ID]",
  #     "sub": "[unique Google account identifier for the user]",
  #     "email": "erikpukinskis@gmail.com",
  #     "email_verified": true,
  #     "nbf": 1744385945, (not before, timestamp when token becomes valid)
  #     "name": "Erik Pukinskis",
  #     "picture": "https://lh3.googleusercontent.com/a/ACg8ocIkbIR9zlsrS6BV-XhHCiTS6Wy5sPPg6S3dN3NzXA35aAA1Q1SV=s96-c",
  #     "given_name": "Erik",
  #     "family_name": "Pukinskis",
  #     "iat": 1744386245, (issued at)
  #     "exp": 1744389845, (expires at)
  #     "jti": "fd570f29abe48c1a933b8fd741854c5d4d7aaa99" (unique identifier for the token)
  #   }
  def self.verify_id_token(id_token)
    # Using googleauth to verify the token but without storing it
    begin
      payload = Google::Auth::IDTokens.verify_oidc(
        id_token,
        aud: ENV["GOOGLE_CLIENT_ID"]
      )
      payload
    rescue => e
      Rails.logger.error("ID token verification error: #{e.message}")
      nil
    end
  end

  # Exchanges a Google ID token for an access token via HTTP request
  #
  # @param id_token [String] The JWT ID token to exchange
  # @return [Hash, nil] The token response containing access_token or nil if failed
  def self.exchange_id_token_for_access_token(id_token)
    # Explicit HTTP request to exchange the ID token for an access token
    uri = URI("https://oauth2.googleapis.com/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    request.body = {
      id_token: id_token,
      client_id: ENV["GOOGLE_CLIENT_ID"],
      client_secret: ENV["GOOGLE_CLIENT_SECRET"],
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer"
    }.to_json

    begin
      response = http.request(request)
      return JSON.parse(response.body) if response.code == "200"
      Rails.logger.error("Token exchange error: #{response.body}")
      nil
    rescue => e
      Rails.logger.error("Token exchange request error: #{e.message}")
      nil
    end
  end
end
