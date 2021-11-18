class UserSessionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :created_at, :updated_at

  attribute :token do |user_validate, params|
    params[:token]
  end
end
