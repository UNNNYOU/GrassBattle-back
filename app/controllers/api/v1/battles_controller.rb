class Api::V1::BattlesController < ApplicationController
  include Pagination

  def index
    @user_paginated = User.where.not(id: @current_user.id).order(created_at: :desc).page(params[:page]).per(8)
    @pagination = pagination(@user_paginated)

    render json: {
      users: ActiveModelSerializers::SerializableResource.new(@user_paginated, each_serializer: UserSerializer),
      current_user: ActiveModelSerializers::SerializableResource.new(@current_user, serializer: UserSerializer),
      pagination: @pagination
    }
  end
end
