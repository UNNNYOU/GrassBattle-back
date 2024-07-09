class Api::V1::UsersController < ApplicationController
  def home
    @experience_histories = @current_user.user_status.experience_histories.order(created_at: :desc).limit(30)
    @week_contribution_histories = @current_user.user_status.week_contribution_histories.order(created_at: :desc).limit(7)
    @week_contribution_histories_asc = @week_contribution_histories.reverse
    @avatar_count = Avatar.all.count

    render json: {
      current_user: ActiveModelSerializers::SerializableResource.new(@current_user, serializer: UserSerializer),
      experience_histories: ActiveModelSerializers::SerializableResource.new(@experience_histories,
                                                                             each_serializer: ExperienceHistorySerializer),
      week_contribution_histories: ActiveModelSerializers::SerializableResource.new(@week_contribution_histories_asc,
                                                                                    each_serializer: WeekContributionHistorySerializer),
      avatar_count: @avatar_count
    }, status: :ok
  end

  def show
    user = User.find(params[:id])
    experience_histories = user.user_status.experience_histories.order(created_at: :desc).limit(30)
    week_contribution_histories = user.user_status.week_contribution_histories.order(created_at: :desc).limit(7)
    week_contribution_histories_asc = week_contribution_histories.reverse

    render json: {
      user: ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer),
      experience_histories: ActiveModelSerializers::SerializableResource.new(experience_histories,
                                                                             each_serializer: ExperienceHistorySerializer),
      week_contribution_histories: ActiveModelSerializers::SerializableResource.new(week_contribution_histories_asc,
                                                                                    each_serializer: WeekContributionHistorySerializer)
    }, status: :ok
  end

  def update
    @current_user.update!(user_params)
    render json: @current_user, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:name, :avatar_id)
  end
end
