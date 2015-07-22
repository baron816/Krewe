class GroupsController < ApplicationController
	def show
		group = Group.find(params[:id])
		@group_show = GroupShow.new(group, params[:page])

		redirect_to user_path(current_user) unless @group_show.includes_user?(current_user)
		@notifications.dismiss_group_notifications_from_group(group)
	end

	def drop_user
		@group = Group.includes(:users).find(params[:id])
		@group.drop_user(current_user)
		redirect_to user_path(current_user)
	end
end
