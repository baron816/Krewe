class GroupShow
  attr_reader :group, :user, :page, :per_page
  delegate :ripe_for_expansion?, :primary_group?, :users_count, :expand_group_votes_size, :includes_user?, to: :group
  delegate :any?, to: :activities, prefix: true
  delegate :any?, :count, to: :messages, prefix: true

  def initialize(group, user, page)
    @group = group
    @user = user
    @page = page
    @per_page = 5
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
    @users ||= group.users
  end

  def activities
    @activities ||= group.future_activities.includes(:users)
  end

  def messages
    @messages ||= group.messages.includes(:poster).paginate(page: page, per_page: per_page).order(created_at: :desc)
  end

  def new_message
    @message ||= Message.new(messageable_id: group.id, poster_id: user, messageable_type: group.class)
  end

  def one_user?
    users.count == 1
  end

  def multiple_pages?
    messages_count > per_page
  end
end
