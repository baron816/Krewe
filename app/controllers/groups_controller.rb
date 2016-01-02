class GroupsController < ApplicationController
	def show
		group = Group.friendly.find(params[:id])
		authorize! :read, group
		@group_show = GroupShow.new(group, current_user, params[:page])

		current_user.dismiss_group_notifications_from_group(group)
	end

	def drop_user
		@group = Group.friendly.find(params[:id])
		authorize! :read, @group

		@group.drop_user(current_user)
		redirect_to root_path
	end
end
