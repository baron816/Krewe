class UserNotification
  attr_reader :user, :notifications
  def initialize(user)
    @user = user
    @notifications = user.notifications
  end

  def dismiss_personal_notifications_from_user(this_user)
    notifications.dismiss_personal_notifications_from_user(this_user)
  end

  def unviewed_personal_notifications_from_user_count(friend)
    notifications.unviewed_personal_notifications_from_user_count(friend)
  end

  def unviewed_group_notification_count(group)
    notifications.unviewed_group_notification_count(group)
  end

  def dismiss_group_notifications_from_group(group)
    notifications.dismiss_group_notifications_from_group(group)
  end

  def unviewed_notifications
    notifications.unviewed_notifications
  end

  def unviewed_notifications_count
    notifications.unviewed_notifications_count
  end

  def unviewed_category_notifications(category)
    notifications.unviewed_category_notifications(category)
  end

  def dismiss_activity_notification(activity)
    notifications.dismiss_activity_notification(activity)
  end

  def unviewed_activity_notifications_count(activity)
    notifications.unviewed_activity_notifications_count(activity)
  end
end
