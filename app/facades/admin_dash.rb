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

  def completed_sign_up_count
    User.where(sign_up_complete: true).count
  end

  def completion_ratio
    ((completed_sign_up_count.to_f / users_count.to_f) * 100).round(2)
  end
end
