class ActivityShow
  attr_reader :activity, :user, :page

  def initialize(params = {})
    @activity = params[:activity]
    @user = params[:user]
    @page = params[:page]
  end

  delegate :group, :plan, :latitude, :longitude, :appointment, :location, :proposed_by?, :users, :group_includes_user?, :user_going?, to: :activity
  delegate :name, to: :group, prefix: true
  delegate :next_page, to: :messages

  def new_message
    Message.new(messageable_id: activity.id, poster_id: user, messageable_type: activity.class)
  end

  def messages
    @messages ||= activity.messages.page(page).per(per_page).order(created_at: :desc)
  end

  def note_count
    @note_count ||= user.unviewed_activity_message_notifications_count(activity)
  end

  private
  def per_page
    note_count
    dismiss_notifications
    (note_count || 0) >= 5 ? note_count : 5
  end

  def dismiss_notifications
    user.dismiss_activity_notification(@activity)
  end
end
