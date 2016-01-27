class UserMailer < ApplicationMailer

  def user_message_alert(message)
    @message = message
    messageable = @message.messageable

    mail to: messageable.email, subject: "#{@message.poster_name} sent you a message"
  end
end
