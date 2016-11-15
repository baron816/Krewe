module Groups
  class ExpandGroup
    include ApplicationHelper
    attr_reader :group

    delegate :degree, :category, :age_group, :latitude, :longitude, :user_limit, :id, to: :group

    def initialize(expanding_group)
      @group = expanding_group
    end

    def expand_group
      if find_mergeable_group
        new_group = merge_groups
      else
        group.ready_to_expand = true
      end
      set_expanded

      new_group
    end

    private
    def find_mergeable_group
      @mergeable_group ||= Group.category_groups(category).same_age(age_group).degree_groups(degree).where.not(id: id).near([latitude, longitude], 0.5).ready_groups.first
    end

    def merge_groups
      new_group = Group.create(new_group_params)
      new_group.users << (group.users + find_mergeable_group.users)

      set_ready_to_expand_to_false
      GroupMailer.delay.expand_group(new_group)
      new_group
    end

    def set_ready_to_expand_to_false
      find_mergeable_group.ready_to_expand = false
      find_mergeable_group.save
    end

    def set_expanded
      group.has_expanded = true
      group.save

      group.expand_group_votes.delete_all
    end

    def mean_coordinates
      {longitude: mean(longitude, find_mergeable_group.longitude), latitude: mean(latitude, find_mergeable_group.latitude)}
    end

    def new_group_params
      {category: category, age_group: age_group, user_limit: new_group_user_limit, can_join: false, degree: new_degree}.merge(mean_coordinates)
    end

    def new_group_user_limit
      user_limit * 2
    end

    def new_degree
      degree + 1
    end
  end
end
