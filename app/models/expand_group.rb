class ExpandGroup
  attr_reader :group

  delegate :degree, :category, :latitude, :longitude, :user_limit, :id, to: :group

  def initialize(expanding_group)
    @group = expanding_group
  end

  def expand_group
    if find_mergable_group
      new_group = merge_groups
    else
      group.ready_to_expand = true
    end
    group.has_expanded = true
    group.save

    group.expand_group_votes.delete_all

    new_group
  end

  private
  def find_mergable_group
    @mergeable_group ||= group.class.category_groups(category).degree_groups(degree).where.not(id: id).near([latitude, longitude], 0.5).ready_groups.first
  end

  def merge_groups
    mid_lng, mid_lat = ApplicationHelper.mean(longitude, find_mergable_group.longitude), ApplicationHelper.mean(latitude, find_mergable_group.latitude)

    new_group = Group.create(longitude: mid_lng, latitude: mid_lat, category: category, user_limit: new_group_user_limit, can_join: false, degree: new_degree)
    new_group.users << (group.users + find_mergable_group.users)

    set_ready_to_expand_to_false
    new_group
  end

  def set_ready_to_expand_to_false
    find_mergable_group.ready_to_expand = false
    find_mergable_group.save
  end

  def new_group_user_limit
    user_limit * 2
  end

  def new_degree
    degree + 1
  end

end
