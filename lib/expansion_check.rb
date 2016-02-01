class ExpansionCheck
  attr_reader :group
  def initialize(group)
    @group = group
  end

  def ripe_for_expansion?
	  aged?(1.month) && group.attended_activities_count >= 4 && group.can_join == false && group.has_expanded == false && group.ready_to_expand == false
	end

  def ripe_and_voted?
    ripe_for_expansion? && voted_to_expand?
  end

  private
  def aged?(period)
    (Time.now - group.created_at) > period
  end

  def voted_to_expand?
    group.expand_group_votes_size == group.users_count
  end
end
