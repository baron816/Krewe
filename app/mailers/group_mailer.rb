class GroupMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.group_mailer.join_group.subject
  #
  def join_group(params = {})
    @user = params[:user]
    @group = params[:group]
    @poster = params[:poster]

    mail to: @user.email, subject: "#{@poster.name} joined group #{@group.name}"
  end

  def activity_proposal(user, activity)
    @user = user
    @activity = activity

    mail to: @user, subject: "#{@activity.proposer} proposed an activity: #{@activity.plan}"
  end
end
