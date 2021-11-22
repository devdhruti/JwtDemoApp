class UserGenerator
  class ParameterNotFound < StandardError; end
  class DuplicateError < StandardError; end
  class InvalidCredentials < StandardError; end
  class ConfirmationError < StandardError; end
  
  attr_reader :user, :user_token
  
  def generate!(params)
    # validates parameters
    raise ParameterNotFound, 'Missing email' if params[:email].blank?
    
    user = User.find_by(email: params[:email].downcase)
    # validates email
    raise DuplicateError, 'This email already exists' if user.present?
    
    user = User.new(params)
    user.skip_confirmation_notification! 
    user.save!
    user.send_confirmation_instructions
    @user = user
    true
  end
  
  def validate!(params)
    #validates parameters
    raise ParameterNotFound, 'Missing email' if params[:email].blank?
    raise ParameterNotFound, 'Missing password' if params[:password].blank?
    
    user = User.find_by(email: params[:email].try(:downcase))
    raise ParameterNotFound, 'Email does not exist' if !user.present? #validates user email
    raise InvalidCredentials, 'Invalid Password' unless user.valid_password?(params[:password]) #validates user password
    raise ConfirmationError, 'Your email address is not confirmed' unless user.confirmed?

    user_token = UserToken.find_or_initialize_by(user_id: user.id)
    #generate user token
    user_token.token = JWT.encode({user_id: user.id},Rails.application.secrets.secret_key_base, 'HS256')

    user.save!
    user_token.save!

    @user = user
    @user_token = user_token
  end
  
  def confirmation!(params)
    #validates parameters
    raise ParameterNotFound, 'Missing confirmation token' if params[:confirmation_token].blank?

    user  = User.find_by(confirmation_token: params[:confirmation_token])
    raise DuplicateError, 'Invalid confirmation token' if user.blank?
    user =  User.confirm_by_token(params[:confirmation_token])
    user.confirmation_token = nil
    user.save!
    @user = user

    true
  end

end
