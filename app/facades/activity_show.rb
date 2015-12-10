class ActivityShow
  attr_reader :activity, :user

  def initialize(activity, user)
    @activity = activity
    @user = user
  end

  delegate :group, :plan, :latitude, :longitude, :appointment, :location, :proposed_by?, :users, :group_includes_user?, :user_going?, to: :activity
  delegate :name, to: :group, prefix: true

  def new_message
    Message.new(messageable_id: activity.id, poster_id: user, messageable_type: activity.class)
  end

  def messages
    @messages ||= activity.messages.order(created_at: :asc)
  end

end
