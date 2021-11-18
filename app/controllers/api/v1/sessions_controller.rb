class Api::V1::SessionsController < Api::V1::AuthenticatedController
  skip_before_action :authorize_user!, only: %i[create], raise: false
  
  # POST /api/v1/users/sign_in
  def create
    begin
      ug = UserGenerator.new   
      ug.validate!(user_params)

    rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError,  UserGenerator::ConfirmationError, UserGenerator::InvalidCredentials => e
      render_exception(e, 422) && return
    end
    json_response(UserSessionSerializer.new(
      ug.user,
      { params: 
        { 
          token: ug.user_token.token
        }
      }
    ).serializable_hash[:data][:attributes])
  end
  
  # DELETE /api/v1/logout
  def destroy
    begin      
      current_user_token.destroy

    rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError => e
      render_exception(e, 422) && return
    end
    render json: { success: true, data: {}, errors: [] }, status: 200
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
  