class UserPublicProfile
  attr_reader :user, :current_user, :page, :per_page
  def initialize(user, current_user, page)
    @user = user
    @current_user = current_user
    @page = page
    @per_page = 5
  end

  delegate :name, :email, :category, :id, to: :user, prefix: true
  delegate :any?, :count, to: :personal_messages, prefix: true
  delegate :next_page, to: :personal_messages

  def user_location
    user.address.split(',')[1..-1].join(',')
  end

  def personal_messages
    @personal_messages ||= Message.personal_messages(user, current_user).includes(:poster).page(page).per(per_page)
  end

  def new_message
    Message.new(messageable_id: user.id, poster_id: current_user, messageable_type: user.class)
  end

  def own_profile?
    @user == current_user
  end
end
