class NowController < ApplicationController
  def index
    redirect_to auth_sign_in_path
  end
end
