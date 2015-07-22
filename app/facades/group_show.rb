class GroupShow
  attr_reader :group, :page

  def initialize(group, page)
    @group = group
    @page = page
  end

  def users
    group.users.includes(:drop_user_votes)
  end

  def activities
    group.future_activities.includes(:users)
  end

  def messages
    group.messages.includes(:user).order(created_at: :desc).paginate(page: page, per_page: 5)
  end

  def new_message
    @message ||= Message.new
  end

  def includes_user?(user)
    users.include?(user)
  end

  def one_user?
    users.count == 1
  end
end
