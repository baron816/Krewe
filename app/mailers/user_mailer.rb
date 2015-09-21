class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user

    mail to: user.email, subject: "Reset Krewe Password"
  end

  def mention_alert(message, user)
    @user = user
    @message = message

    mail to: user.email, subject: "#{@message.poster_name} mentioned you in a post"
  end
end
