class NowController < ApplicationController
  def index
    # The middleware will handle redirecting unauthenticated users
    # Just render the view for authenticated users

    # @user = User.find(params[:hashid])
  end
end
