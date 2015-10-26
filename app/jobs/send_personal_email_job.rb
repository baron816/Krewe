class SendPersonalEmailJob < ActiveJob::Base
  queue_as :default

  def perform(message)
    UserMailer.user_message_alert(message).deliver_later
  end
end
