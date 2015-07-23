class UserPublicProfile
  def initialize(user, current_user, page)
    @user = user
    @current_user = current_user
    @page = page
  end

  def user_name
    user.name
  end

  def user_email
    user.email
  end

  def user_location
    "#{user.city}, #{user.state}"
  end

  def user_category
    user.category
  end

  def user_id
    user.id
  end

  def personal_messages
    @messages ||= PersonalMessage.users_messages(first_user: user, second_user: current_user).includes(:sender).paginate(page: page, per_page: 5)
  end

  def new_personal_message
    @personal_message = PersonalMessage.new
  end

  def own_profile?
    @user == current_user
  end

  private
  attr_reader :user, :current_user, :page
end
