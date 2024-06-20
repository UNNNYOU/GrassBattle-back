class Api::V1::UsersController < ApplicationController
  def home
    render json: @current_user, status: :ok, each_serializer: UserSerializer
  end
end
