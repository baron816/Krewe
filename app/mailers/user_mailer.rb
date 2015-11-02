class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user

    mail to: user.email, subject: "Reset Krewe Password"
  end

  def mention_alert(message, user)
    p "{{{{{{{{{success}}}}}}}}}"
    @user = user
    @message = message

    mail to: user.email, subject: "#{@message.poster_name} mentioned you in a post"
  end

  def user_message_alert(message)
    @message = message

    mail to: @message.messageable.email, subject: "#{@message.poster_name} sent you a message"
  end
end
