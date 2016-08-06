class UserRequestMailer < ApplicationMailer
  # Default Mail Values
  default from: 'miguel@pcuervo.com'

  # Send a message to AMAP Admin Users when there a new user request
  # * *Params:* 
  #   - +user_request+ -> NewUserRequest
  def new_user_request_email( user_request )
    @user_request = user_request
    # I am overriding the 'to' default
    mail( to: 'miguel@pcuervo.com', subject: 'Un nuevo usuario desea registrarse en la app de AMAP.')
  end

  # Send a message a user once he/she has been approved
  # * *Params:* 
  #   - +user+ -> NewUserRequest
  def new_user_confirmation_email( user, password )
    @user = user
    @password = password
    # I am overriding the 'to' default
    mail( to: @user.email, subject: 'Tu solicitud de cuenta ha sido aprobada')
  end
end
