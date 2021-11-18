class Api::V1::RegistrationsController < Api::V1::AuthenticatedController
  skip_before_action :authorize_user!, only: %i[create], raise: false
  
  # POST /api/v1/users/Sign_up
  def create
    begin
      ug = UserGenerator.new
      ug.generate!(user_params)
    
    rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError => e
      render_exception(e, 422) && return
    end
    json_response(UserSerializer.new(ug.user).serializable_hash[:data][:attributes]) 
  end
  
  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
