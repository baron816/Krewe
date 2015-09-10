class UserPublicProfile
  def initialize(user, current_user)
    @user = user
    @current_user = current_user
  end

  delegate :name, :email, :category, :id, to: :user, prefix: true

  def user_location
    "#{user.city}, #{user.state}"
  end

  def personal_messages
    @messages ||= PersonalMessage.users_messages(first_user: user, second_user: current_user).includes(:sender)
  end

  def any_messages?
    personal_messages.any?
  end

  def new_personal_message
    @personal_message = PersonalMessage.new
  end

  def own_profile?
    @user == current_user
  end

  private
  attr_reader :user, :current_user
end
