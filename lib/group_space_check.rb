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
      set_can_join_as_true
    elsif hit_limit
      set_can_join_as_false
    end
  end

  private
  def set_can_join_as_true
    group.can_join = true
    group.save
  end

  def set_can_join_as_false
    group.can_join = false
    group.save
  end

  def fell_below_limit
    users_count == group.user_limit - 1 && group.can_join == false
  end

  def hit_limit
    users_count == group.user_limit && group.can_join == true
  end
end
