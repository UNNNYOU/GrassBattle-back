class Api::V1::BattlesController < ApplicationController
  def index
    @user = User.all
    render json: @user, status: :ok, each_serializer: UserSerializer
  end
end
