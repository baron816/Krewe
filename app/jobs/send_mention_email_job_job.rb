class SendMentionEmailJobJob < ActiveJob::Base
  queue_as :default

  def perform(message, user)
    UserMailer.mention_alert(message, user).deliver_later
  end
end
