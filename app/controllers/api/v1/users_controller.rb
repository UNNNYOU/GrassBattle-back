class Api::V1::UsersController < ApplicationController
  def home
    @experience_histories = @current_user.user_status.experience_histories.order(created_at: :desc).limit(30)
    @week_contribution_histories = @current_user.user_status.week_contribution_histories.order(created_at: :desc).limit(7)

    render json: {
      current_user: ActiveModelSerializers::SerializableResource.new(@current_user, serializer: UserSerializer),
      experience_histories: ActiveModelSerializers::SerializableResource.new(@experience_histories, each_serializer: ExperienceHistorySerializer),
      week_contribution_histories: ActiveModelSerializers::SerializableResource.new(@week_contribution_histories, each_serializer: WeekContributionHistorySerializer)
    }, status: :ok
  end
end
