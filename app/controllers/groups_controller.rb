class GroupsController < ApplicationController
	def show
		@group = Group.find(params[:id])
		@users = @group.users.includes(:drop_user_votes)
		redirect_to user_path(current_user) unless @users.include?(current_user)
		@notifications.dismiss_group_notifications_from_group(@group)
		@messages = @group.messages.includes(:user).order(created_at: :desc).paginate(page: params[:page], per_page: 5)
		@activities = @group.upcoming_activities.includes(:users)
		@message = Message.new
	end

	def drop_user
		@group = Group.includes(:users).find(params[:id])
		@group.drop_user(current_user)
		redirect_to user_path(current_user)
	end
end
