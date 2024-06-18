module JwtAuthenticator
  class UnableAuthorizationError < StandardError; end

  def authenticate
    authorization_header = request.headers['Authorization']
    raise UnableAuthorizationError.new('認証情報が不足しています。') if authorization_header.blank?

    # トークンをヘッダーから取得。
    encoded_token = authorization_header.split('Bearer ').last
    raise UnableAuthorizationError.new('無効な認証形式です。') if encoded_token.blank?

    logger.debug "encoded_token: #{encoded_token}"

    # トークンを復号化
    decoded_token_payload = decode(encoded_token)

    logger.debug "decoded_token_payload: #{decoded_token_payload}"

    @current_user = UserAuthentication.find_by(uid: decoded_token_payload["uid"]).user

    raise UnableAuthorizationError.new('認証できません。') if @current_user.blank?

    @current_user
  end

  # 暗号化処理
  def encode_access_token(uid_info)
    exp_info = Time.now.to_i + 900
    payload = { uid: uid_info, exp: exp_info }
    JWT.encode(payload, ENV['JWT_SECRET_KEY'], 'HS256')
  end

  def encode_refresh_token(uid_info)
    exp_info = Time.now.to_i + 24 * 3600
    payload = { uid: uid_info, exp: exp_info }
    JWT.encode(payload, ENV['JWT_SECRET_KEY'], 'HS256')
  end

  # 復号化処理
  def decode(encoded_token)
    decoded_token = JWT.decode(encoded_token, ENV['JWT_SECRET_KEY'], true, algorithm: 'HS256')
    decoded_token.first
  rescue JWT::DecodeError => e
    raise UnableAuthorizationError.new("トークンの復号化に失敗しました: #{e.message}")
  end
end
