class DropUser
  attr_reader :group, :user
  delegate :users, to: :group
  delegate :empty?, to: :users, prefix: true
  delegate :notifications, :votes_to_drop, to: :user
  delegate :dismiss_all_notifications, to: :notifications

  def initialize(group, user)
    @group = group
    @user = user
  end

  def drop
    users.delete(user)
    Groups::GroupSpaceCheck.new(group, user).check_space
    remember_dropped_group_id

    delete_drop_votes
    dismiss_all_notifications
    group.delete if users_empty?
  end

  private
  def remember_dropped_group_id
    user.dropped_group_ids << group.id
    user.save
  end

  def delete_drop_votes
    votes_to_drop.delete_all
  end
end
