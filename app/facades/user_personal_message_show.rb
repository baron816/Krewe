class UserPersonalMessageShow
  attr_reader :user, :current_user, :page
  def initialize(user, current_user, page)
    @user = user
    @current_user = current_user
    @page = page
  end

  delegate :name, :email, :category, :id, :city, to: :user, prefix: true
  delegate :any?, :count, to: :personal_messages, prefix: true
  delegate :next_page, to: :personal_messages

  def messages
    @messages ||= Message.personal_messages(user, current_user).page(page).per(per_page)
  end

  def new_message
    Message.new(messageable_id: user.id, poster_id: current_user, messageable_type: user.class)
  end

  def own_profile?
    @user == current_user
  end

  private
  def per_page
    note_count = current_user.unviewed_personal_notifications_from_user_count(user)
    dismiss_notifications
    (note_count || 0) >= 5 ? note_count : 5
  end

  def dismiss_notifications
    current_user.dismiss_personal_notifications_from_user(user)
  end
end
