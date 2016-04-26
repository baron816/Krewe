class GroupMailer < ApplicationMailer

  def group_filled(group)
    @group = group
    @users = @group.users
    @emails = @users.pluck(:email)

    mail bcc: @emails, subject: "Congratulations, your Krewe group is complete. Time to have fun."
  end

  def activity_proposal(activity)
    @activity = activity
    @group = @activity.group
    @poster = @activity.proposer
    @users = @group.users

    mail bcc: emails("proposal"), subject: "#{@poster.name} proposed an activity: #{@activity.plan}"
  end

  def mention_alert(message, users)
    @users = users
    @message = message
    @poster = @message.poster

    mail bcc: emails("mention"), subject: "#{@poster.name} mentioned you in a post"
  end

  def expand_group(group)
    @group = group
    @users = @group.users

    mail bcc: emails("expand"), subject: "You have a new group!"
  end

  private

  def emails(type)
    @users.inject([]) do |results, user|
      results << user.email if user != @poster && user.send_notification?(type)
      results
    end
  end
end
