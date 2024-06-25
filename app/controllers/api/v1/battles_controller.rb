class Api::V1::BattlesController < ApplicationController
  include Pagination

  def index
    @user_paginated = User.order(created_at: :desc).page(params[:page]).per(8)
    @pagination = pagination(@user_paginated)

    render json: { users: @user_paginated, pagination: @pagination }, status: :ok, each_serializer: UserSerializer
  end
end
