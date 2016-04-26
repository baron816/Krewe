class GroupSpaceCheck
  attr_reader :group, :user
  delegate :users, to: :group
  delegate :count, to: :users, prefix: true

  def initialize(group, user)
    @group = group
    @user = user
  end

  def check_space
    if fell_below_limit
      reopen_group
    elsif hit_limit
      close_group
    end
  end

  private
  def reopen_group
    group.can_join = true
    group.save
  end

  def close_group
    group.can_join = false
    group.save
    GroupComplete.perform_in(5.minutes, group.id)
  end

  def fell_below_limit
    users_count == group.user_limit - 1 && group.can_join == false
  end

  def hit_limit
    users_count == group.user_limit && group.can_join == true
  end
end
