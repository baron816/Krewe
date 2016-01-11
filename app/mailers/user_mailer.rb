class UserMailer < ApplicationMailer

  def beta_code(beta_code)
    @beta_code = beta_code

    mail to: @beta_code.email, subject: "Finish Signing Up For Krewe"
  end

  def password_reset(user)
    @user = user

    mail to: @user.email, subject: "Reset Krewe Password"
  end

  def user_message_alert(message)
    @message = message
    messageable = @message.messageable

    mail to: messageable.email, subject: "#{@message.poster_name} sent you a message"
  end
end
