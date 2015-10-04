class GroupShow
  attr_reader :group, :user
  delegate :ripe_for_expansion?, :primary_group?, :users_count, :expand_group_votes_size, :includes_user?, to: :group
  delegate :any?, to: :activities, prefix: true
  delegate :any?, to: :messages, prefix: true

  def initialize(group, user)
    @group = group
    @user = user
  end

  def names_data
    group.user_names_hash.to_json.html_safe
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
    @messages ||= group.messages.includes(:poster)
  end

  def new_message
    @message ||= Message.new(messageable_id: group.id, poster_id: user, messageable_type: group.class)
  end

  def one_user?
    users.count == 1
  end
end
