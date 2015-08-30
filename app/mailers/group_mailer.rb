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

    mail to: @user.email, subject: "Krewe: #{@poster.name} joined group #{@group.name}"
  end
end
