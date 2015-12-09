class UserMailer < ApplicationMailer

  def beta_code(beta_code)
    @beta_code = beta_code

    mail to: @beta_code.email, subject: "Sign up for Krewe!"
  end

  def password_reset(user)
    @user = user

    mail to: @user.email, subject: "Reset Krewe Password"
  end

  def mention_alert(message, user)
    @user = user
    @message = message

    mail to: @user.email, subject: "#{@message.poster_name} mentioned you in a post"
  end

  def user_message_alert(message)
    @message = message
    messageable = @message.messageable

    mail to: messageable.email, subject: "#{@message.poster_name} sent you a message"
  end
end
