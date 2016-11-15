class FindGroup
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def find_or_create
    group = Group.search(params_with_group_ids)

    if group
      group.users << user
      if group.degree == 1
        Groups::GroupSpaceCheck.new(group, user).check_space 
        JoinNotification.new(group, user).send_notifications
      end
    else
      group = user.groups.create(user_params)
    end
    group
  end

  private
  def user_params
    {category: user.category, age_group: user.age_group, latitude: user.latitude, longitude: user.longitude}
  end

  def params_with_group_ids
    user_params.merge({group_ids: user.dropped_group_ids})
  end
end
