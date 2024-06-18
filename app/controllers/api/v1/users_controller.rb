class Api::V1::UsersController < ApplicationController
  def mypage
    user_status = UserStatus.find_by(user_id: @current_user.id)
    render json: { current_user: @current_user, user_status: user_status }, status: :ok
  end
end
