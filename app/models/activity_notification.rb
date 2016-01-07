class ActivityNotification
  attr_reader :activity, :type

  delegate :group_users, :notifications, :proposer, to: :activity
  def initialize(activity, type = "Activity")
    @activity = activity
    @type = type
  end

  def send_notifications
    group_users.each do |user|
      notifications.create(user: user, poster: proposer, notification_type: type).delay unless user == proposer
    end

    GroupMailer.delay.activity_proposal(activity) if type == "Activity"
  end
end
