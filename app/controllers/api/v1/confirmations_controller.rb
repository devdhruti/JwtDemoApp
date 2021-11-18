class Api::V1::ConfirmationsController < Api::V1::AuthenticatedController
  skip_before_action :authorize_user!, only: %i[confirm_email], raise: false

  # POST /api/v1/confirm_email
  def confirm_email
    begin 
      ug = UserGenerator.new

    rescue UserGenerator::ParameterNotFound, UserGenerator::DuplicateError => e
			render_exception(e, 422) && return
		end
    ug.confirmation!(user_params)
    render json: { success: true, data: {}, errors: [] }, status: 200
  end

  private
  def user_params
    params.require(:user).permit(:confirmation_token)
  end
end
