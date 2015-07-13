class GroupsController < ApplicationController
	def show
		@group = Group.includes(:activities).find(params[:id])
		@users = @group.users
		redirect_to user_path(current_user) unless @users.include?(current_user)
		@notifications.dismiss_group_notifications_from_group(@group)
		@messages = @group.messages.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
		@message = Message.new
		@activity = Activity.new
		@vote = DropUserVote.new
	end

	def drop_user
		@group = Group.includes(:users).find(params[:group_id])
		@group.drop_user(current_user)
		redirect_to user_path(current_user)
	end
end
