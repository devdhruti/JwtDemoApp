class UserTokenValidator
  class ParameterNotFound < StandardError; end
  class TokenNotFound < StandardError; end
  class UserNotFound < StandardError; end

  attr_reader :user, :user_token

  def validate!(token)
    #validates token presence
    raise ParameterNotFound, 'Token is missing' if token.blank?
    
    user_token = UserToken.find_or_initialize_by(token: token)
    user = User.find_by id: user_token.user_id
    raise UserNotFound, 'User is missing' if user.blank? #validates user

    #decode token
    decode_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })
    raise TokenNotFound, 'Invalid user token' if !(decode_token[0] == {"user_id"=>user.id})

    @user_token = user_token
    @user = user

    true
  end
end
