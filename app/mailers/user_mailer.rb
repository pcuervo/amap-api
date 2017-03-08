class UserMailer < ApplicationMailer
  default from: 'Happitch <amap.happitch@gmail.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset( user )
    @user = user
    mail( to: @user.email, subject: 'Restablecer contraseña Happitch' )
  end

  def new_client_email( user, password, pitch )
    @user = user
    @pitch = pitch
    @password = password
    mail( to: @user.email, subject: 'Una agencia ha dado de alta un pitch con tu correo en Happitch' )
  end

  def new_pitch_client( user, pitch )
    @user = user
    @pitch = pitch
    mail( to: @user.email, subject: 'Una agencia ha dado de alta un pitch con tu correo en Happitch' )
  end

  def new_user( user, password )
    @user = user
    @password = password
    #mail( to: @user.email, subject: 'Una agencia ha dado de alta un pitch con tu correo en Happitch' )
    mail( to: @user.email, subject: '¡Bienvenido a Happitch!', bcc: ['miguel@pcuervo.com'] )
  end

  def evaluated_pitch( user, pitch )
    @user = user
    @pitch = pitch
    mail( to: @user.email, subject: 'Se ha evaluado tu pitch dentro de Happitch', bcc: ['miguel@pcuervo.com'] )
  end
end
