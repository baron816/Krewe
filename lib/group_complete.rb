class GroupComplete
  include Sidekiq::Worker

  def perform(group_id)
    group = Group.find(group_id)
    GroupMailer.delay.group_filled(group) unless group.can_join?
  end
end
