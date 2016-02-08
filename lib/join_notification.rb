class JoinNotification
  attr_reader :group, :new_user

  delegate :users, :notifications, to: :group
  def initialize(group, new_user)
    @group = group
    @new_user = new_user
  end

  def send_notifications
     users.each do |user|
      notifications.create(user: user, poster: new_user, notification_type: "Join").delay unless user == new_user
    end

    GroupMailer.delay.join_group({group: group, poster: new_user})
  end
end
