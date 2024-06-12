class SessionsController < ApplicationController
  def create
    user_info = request.env['omniauth.auth']

    uid_info = user_info['uid']
    provider_info = user_info['provider']
    github_id_info = user_info['info']['nickname']
    token_info = token_generator(uid_info, provider_info)

    user_auth = UserAuthentications.find_by(uid: uid_info, provider: provider_info)

    if user_auth
      redirect_to "#{ENV['FRONT_URL']}?token=#{user_auth.token}"
    else
      user = User.create(name: 'GRASS BATTLE MEMBER', github_id: github_id_info)
      user_auth = UserAuthentications.create(user_id: user.id, uid: uid_info, provider: provider_info, token: token_info)
      redirect_to "#{ENV['FRONT_URL']}?token=#{user_auth.token}"
    end
  end

  private

  def token_generator(uid_info, provider_info)
    exp_info = Time.now.to_i + 24 * 3600
    payload = { github_id: uid_info, provider: provider_info, exp: exp_info }
    JWT.encode(payload, ENV['SECRET_KEY_BASE'], 'HS256')
  end
end
