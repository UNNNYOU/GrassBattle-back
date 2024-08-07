class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:create]
  include CreateUserStatus

  def create
    user_info = request.env['omniauth.auth']
    raise 'GitHub情報の取得に失敗しました' unless user_info

    uid_info = user_info['uid']
    github_uid_info = user_info['info']['nickname']
    token_info = encode_access_token(uid_info)

    user_auth = UserAuthentication.find_by(uid: uid_info)

    unless user_auth
      user = User.create(name: 'MEMBER', github_uid: github_uid_info, avatar_id: 1)
      UserAuthentication.create(user_id: user.id, uid: uid_info)

      set_experience_points(user)
      set_contributions(user)
    end
    redirect_to "#{ENV['FRONT_URL']}/auth?token=#{token_info}", allow_other_host: true
  rescue StandardError => e
    Rails.logger.error("認証エラー: #{e.message}")
    redirect_to "#{ENV['FRONT_URL']}?error=authentication_failed"
  end

  def update
    access_token_info = encode_access_token(@current_user.user_authentication[:uid])
    refresh_token_info = encode_refresh_token(@current_user.user_authentication[:uid])
    render json: { access_token: access_token_info, refresh_token: refresh_token_info }, status: :ok
  rescue StandardError => e
    Rails.logger.error("認証エラー: #{e.message}")
    render json: { error: 'authentication_failed' }, status: :unauthorized
  end
end
