class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:create]
  include CreateUserStatus

  def create
    # githubから情報を取得
    user_info = request.env['omniauth.auth']
    raise 'GitHub情報の取得に失敗しました' unless user_info

    # ユーザー情報を取得
    uid_info = user_info['uid']
    github_id_info = user_info['info']['nickname']
    token_info = encode_access_token(uid_info)

    # ユーザー情報が存在するか確認
    user_auth = UserAuthentication.find_by(uid: uid_info)

    if user_auth
      # ユーザー情報が存在する場合はトークンを返却
      redirect_to "#{ENV['FRONT_URL']}/auth?token=#{token_info}", allow_other_host: true
    else
      # ユーザー情報が存在しない場合はユーザー情報を作成してトークンを返却
      user = User.create(name: 'GRASS BATTLE MEMBER', github_id: github_id_info)
      UserAuthentication.create(user_id: user.id, uid: uid_info)

      set_experience_points(user)
      set_contributions(user)

      redirect_to "#{ENV['FRONT_URL']}/auth?token=#{token_info}", allow_other_host: true

    end
  rescue StandardError => e
    # エラーが発生した場合はログを出力してエラーを返却
    Rails.logger.error("認証エラー: #{e.message}")
    redirect_to "#{ENV['FRONT_URL']}?error=authentication_failed"
  end

  def update
    # トークンを再発行
    access_token_info = encode_access_token(@current_user.user_authentication[:uid])
    refresh_token_info = encode_refresh_token(@current_user.user_authentication[:uid])
    # トークンを返却
    render json: { access_token: access_token_info, refresh_token: refresh_token_info }, status: :ok
  rescue StandardError => e
    # エラーが発生した場合はログを出力してエラーを返却
    Rails.logger.error("認証エラー: #{e.message}")
    render json: { error: 'authentication_failed' }, status: :unauthorized
  end
end
