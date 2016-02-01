class MessageNotification
  attr_reader :message

  delegate :messageable, :notifications, :poster, :messageable_type, :content, to: :message
  delegate :users, to: :messageable, prefix: true

  def initialize(message)
    @message = message
  end

  def send_notifications
    case messageable_type
    when 'Activity', 'Topic'
      send_group_or_activity_message_notifications
    when 'User'
      send_user_notification
    end
  end

  private
  def mentioned_user_slugs
    @mentionted_users ||= content.scan(/\b(?<=data-name=\")[^"]+(?=\")/)
  end

  def send_mention_email_alerts
    GroupMailer.delay.mention_alert(message, send_to_users)
  end

  def send_group_or_activity_message_notifications
    messageable_users.each do |user|
       create_notification(user) unless user == poster
    end
    send_mention_email_alerts
  end

  def send_to_users
    mentioned_user_slugs.include?("group") ? messageable_users : messageable_users.users_by_slug(mentioned_user_slugs)
  end

  def send_user_notification
    UserMailer.delay.user_message_alert(message) if !messageable.unviewed_personal_notifications_from_user_count(poster) && messageable.send_notification?('personal')
    create_notification(messageable)
  end

  def create_notification(user)
    notifications.create(user: user, poster: poster, notification_type: "#{messageable_type}Message").delay
  end
end
