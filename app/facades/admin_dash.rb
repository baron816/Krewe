class AdminDash
  def group_count
    Group.count
  end

  def groups
    Group.all
  end

  def users_count
    User.count
  end
end
