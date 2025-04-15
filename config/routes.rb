Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Home page
  root "now#index"

  # Google OAuth
  post "auth/google_oauth2/callback" => "auth#google_oauth2_callback"
  get "auth/sign_in" => "auth#sign_in"
end
