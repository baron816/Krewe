class GroupShow
  attr_reader :group, :page

  def initialize(group, page)
    @group = group
    @page = page
  end

  def user_expand_group_votes(user)
    @group.expand_group_votes.user_votes(user)
  end

  def users
    @users ||= group.users.includes(:drop_user_votes)
  end

  def activities
    @activities ||= group.future_activities.includes(:users)
  end

  def messages
    @messages ||= group.messages.includes(:user).order(created_at: :desc).paginate(page: page, per_page: 5)
  end

  def new_message
    @message = Message.new
  end

  def includes_user?(user)
    users.include?(user)
  end

  def one_user?
    users.count == 1
  end
end
