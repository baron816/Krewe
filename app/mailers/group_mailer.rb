class GroupMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.group_mailer.join_group.subject
  #
  def join_group(params = {})
    @group = params[:group]
    @poster = params[:poster]

    mail bcc: emails("join"), subject: "#{@poster.name} joined group #{@group.name}"
  end

  def activity_proposal(activity)
    @activity = activity
    @group = @activity.group
    @poster = @activity.proposer

    mail bcc: emails("proposal"), subject: "#{@poster.name} proposed an activity: #{@activity.plan}"
  end

  private

  def emails(type)
    @group.users.inject([]) do |results, user|
      results << user.email if user != @poster && user.send_notification?(type)
      results
    end
  end
end
