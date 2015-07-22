class UserPublicProfile
  attr_reader :user, :current_user, :page
  def initialize(user, current_user, page)
    @user = user
    @current_user = current_user
    @page = page
  end

  def personal_messages
    PersonalMessage.users_messages(first_user: user, second_user: current_user).includes(:sender).paginate(page: page, per_page: 5)
  end

  def new_personal_message
    @personal_message = PersonalMessage.new
  end

  def own_profile?
    @user == current_user
  end
end