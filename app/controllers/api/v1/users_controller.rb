class Api::V1::UsersController < ApplicationController
  def home
    @experience_logs = @current_user.user_status.experience_logs.order(created_at: :desc).limit(30)

    render json: {
      current_user: ActiveModelSerializers::SerializableResource.new(@current_user, serializer: UserSerializer),
      experience_logs: ActiveModelSerializers::SerializableResource.new(@experience_logs, each_serializer: ExperienceLogSerializer),
    }, status: :ok
  end
end
