module Authenticable

  # Devise methods overwrites
  def current_user user_token=''
    @current_user ||= User.find_by(auth_token: user_token)
  end

  def authenticate_with_token! user_token
    render json: { errors: "Not authenticated" },
                status: :unauthorized unless user_signed_in? user_token
  end

  def user_signed_in? user_token
    current_user(user_token).present? 
  end

  def authenticate_user
  end
end