class GroupMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.group_mailer.join_group.subject
  #
  def join_group(params = {})
    @group = params[:group]
    @poster = params[:poster]

    mail bcc: emails, subject: "#{@poster.name} joined group #{@group.name}"
  end

  def activity_proposal(params = {})
    @group = params[:group]
    @activity = params[:activity]

    mail bcc: emails, subject: "#{@activity.proposer.name} proposed an activity: #{@activity.plan}"
  end

  private

  def emails
    @group.users.pluck(:email).delete_if { |x| x == User.find(44).email }
  end
end
