class UserRequestMailer < ApplicationMailer
  # Default Mail Values
  default from: 'amap.happitch@gmail.com'

  # Send a message to AMAP Admin Users when there a new user request
  # * *Params:* 
  #   - +user_request+ -> NewUserRequest
  def new_user_request_email( user_request )
    @user_request = user_request
    mail( to: 'miguel@pcuervo.com', subject: 'Un nuevo usuario desea registrarse en la app de AMAP.')
  end

  # Send a message to a user once he/she has been approved (AMAP member)
  # * *Params:* 
  #   - +user+ -> NewUserRequest
  def new_user_confirmation_email( user, password )
    @user = user
    @password = password
    mail( to: @user.email, subject: 'Tu solicitud de cuenta ha sido aprobada')
  end

  # Send a message to a user once he/she has been approved (Not AMAP member)
  # * *Params:* 
  #   - +user+ -> NewUserRequest
  def new_no_amap_user_confirmation_email( user, password )
    @user = user
    @password = password
    mail( to: @user.email, subject: 'Tu solicitud de cuenta ha sido aprobada')
  end

  # Send a message a user once he/she has been approved
  # * *Params:* 
  #   - +user+ -> NewUserRequest
  def new_user_rejection_email( email )
    @email = email
    mail( to: @email, subject: 'Tu solicitud de cuenta ha sido rechazada')
  end
end
