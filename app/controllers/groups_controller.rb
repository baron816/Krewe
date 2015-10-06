class GroupsController < ApplicationController
	def show
		group = Group.friendly.find(params[:id])
		@group_show = GroupShow.new(group, current_user, params[:page])

		redirect_to user_path(current_user) unless @group_show.includes_user?(current_user)
		current_user.dismiss_group_notifications_from_group(group)
	end

	def drop_user
		@group = Group.includes(:users).friendly.find(params[:id])
		@group.drop_user(current_user)
		if @group.primary_group?
			new_group = current_user.find_or_create_group
			redirect_to group_path(new_group)
		else
			redirect_to user_path(current_user)
		end
	end
end
