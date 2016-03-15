class UserMailer < ApplicationMailer

  def user_message_alert(message)
    @message = message
    messageable = @message.messageable

    mail to: messageable.email, subject: "#{@message.poster_name} sent you a message"
  end

  def password_reset(user)
    @user = user

    mail to: @user.email, subject: "Reset Krewe Password"
  end

  def confirm_email(user)
    @user = user

    mail to: @user.email, subject: "Krewe Email Verification"
  end
end
