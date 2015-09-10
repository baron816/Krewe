class GroupShow
  attr_reader :group
  delegate :ripe_for_expansion?, :primary_group?, :users_count, :expand_group_votes_count, :includes_user?, to: :group

  def initialize(group)
    @group = group
  end

  def user_expand_group_votes(user)
    group.expand_group_votes.user_votes(user)
  end

  def not_almost_expandable?
    group.expand_group_votes.size != group.users_count - 1
  end

  def users
    @users ||= group.users.includes(:drop_user_votes)
  end

  def activities
    @activities ||= group.future_activities.includes(:users)
  end

  def messages
    @messages ||= group.messages.includes(:user)
  end

  def any_messages?
    messages.any?
  end

  def new_message
    @message = Message.new
  end

  def one_user?
    users.count == 1
  end
end
