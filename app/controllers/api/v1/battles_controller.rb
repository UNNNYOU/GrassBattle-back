class Api::V1::BattlesController < ApplicationController
  def index
    user = User.all
    user_status = UserStatus.all
    render json: { user: user, user_status: user_status }, status: :ok
  end
end
