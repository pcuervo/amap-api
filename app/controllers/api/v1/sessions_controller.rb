class Api::V1::SessionsController < ApplicationController
  def create
    user_password = params[:user_session][:password]
    user_email = params[:user_session][:email]
    user = user_email.present? && User.find_by(email: user_email)

    if ! user.present?
      invalid_user = User.new
      invalid_user.errors.add(:email, "Email o password incorrecto")
      render json: { errors: invalid_user.errors }, status: 422
      return
    end

    if user.valid_password? user_password
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user
      return
    end
    user.errors.add(:email, "Email o password incorrecto")
    render json: { errors: user.errors }, status: 422
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    if ! user.present? 
      invalid_user = User.new
      invalid_user.errors.add(:auth_token, "No existe ninguna sesión activa con ese token")
      render json: { errors: invalid_user.errors }, status: 422
      return
    end
    user.generate_authentication_token!
    user.save
    head 204
  end

end
