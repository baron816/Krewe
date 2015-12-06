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
    @poster = @activity.proposer

    mail bcc: emails, subject: "#{@poster.name} proposed an activity: #{@activity.plan}"
  end

  private

  def emails
    @group.users.pluck(:email).delete_if { |x| x == @poster.email }
  end
end
