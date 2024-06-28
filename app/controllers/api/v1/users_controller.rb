class Api::V1::UsersController < ApplicationController
  def home
    @experience_histories = @current_user.user_status.experience_histories.order(created_at: :desc).limit(30)

    render json: {
      current_user: ActiveModelSerializers::SerializableResource.new(@current_user, serializer: UserSerializer),
      experience_histories: ActiveModelSerializers::SerializableResource.new(@experience_histories, each_serializer: ExperienceHistorySerializer),
    }, status: :ok
  end
end
