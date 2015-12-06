class AdminDash
  attr_reader :page
  def initialize(page)
    @page = page
  end

  def group_count
    Group.count
  end

  def groups
    @groups ||= Group.all.page(page).per(15)
  end

  def users_count
    User.count
  end
end
