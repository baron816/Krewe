class GroupShow
  attr_reader :group, :user, :page, :per_page
  delegate :primary_group?, :users_count, :expand_group_votes_size, :includes_user?, to: :group
  delegate :any?, :count, to: :activities, prefix: true
  delegate :any?, to: :messages, prefix: true
  delegate :users, :names_data, to: :group
  delegate :count, to: :users, prefix: true
  delegate :name, to: :group, prefix: true
  delegate :next_page, to: :topics

  def initialize(group, user, page)
    @group = group
    @user = user
    @page = page
    @per_page = 5
    dismiss_first_topic_notifications
  end

  def user_expand_group_votes(user)
    group.expand_group_votes.user_votes(user)
  end

  def not_almost_expandable?
    group.expand_group_votes.size != group.users_count - 1
  end

  def activities
    @activities ||= group.future_activities.includes(:users)
  end

  def topics
    @topics ||= group.topics.order(updated_at: :desc).page(page).per(5)
  end

  def topic
    @topic ||= TopicShow.new(topics.first, page, user)
  end

  def dismiss_first_topic_notifications
    user.dismiss_topic_notifications_from_topic(topics.first)
  end

  def new_topic
    @new_topic ||= Topic.new
  end

  def one_user?
    users_count == 1
  end

  def ripe_for_expansion?
    @ripe_for_expansion ||= ExpansionCheck.new(group).ripe_for_expansion?
  end
end
