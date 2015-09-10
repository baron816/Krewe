class GroupsController < ApplicationController
	def show
		group = Group.friendly.find(params[:id])
		@group_show = GroupShow.new(group)

		redirect_to user_path(current_user) unless @group_show.includes_user?(current_user)
		user_notifications.dismiss_group_notifications_from_group(group)
	end

	def drop_user
		@group = Group.includes(:users).friendly.find(params[:id])
		@group.drop_user(current_user)
		redirect_to user_path(current_user)
	end
end
