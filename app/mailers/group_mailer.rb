class GroupMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.group_mailer.join_group.subject
  #
  def join_group(params = {})
    @group = params[:group]
    @poster = params[:poster]
    emails = @group.users.pluck(:email)
    emails.delete(@poster.email)

    mail bcc: emails, subject: "#{@poster.name} joined group #{@group.name}"
  end

  def activity_proposal(params = {})
    @user = params[:user]
    @activity = params[:activity]

    mail to: @user.email, subject: "#{@activity.proposer.name} proposed an activity: #{@activity.plan}"
  end
end
