class ActivitiesController < ApplicationController
	before_action :set_group, only: [:create, :new]
	before_action :set_activity, only: [:add_user, :remove_user]

	def create
		@activity = @group.activities.new(activity_params)

		if @activity.save
			@activity.users << @activity.proposer
			redirect_to group_activity_path(@group, @activity)
		else
			redirect_to group_path(@group), flash: { errors: @activity.errors.full_messages }
		end
	end

	def add_user
		@activity.users << current_user

		redirect_to group_activity_path(@activity.group, @activity)
	end

	def remove_user
		@activity.users.delete(current_user)

		redirect_to current_user
	end

	def show
		@activity = Activity.find(params[:id])
		@notifications.dismiss_activity_notification(@activity)
	end

	def new
		@activity = Activity.new
	end

	private
	def set_activity
		@activity = Activity.find(params[:activity_id])
	end

	def set_group
		@group = Group.find(params[:group_id])
	end

	def activity_params
		params.require(:activity).permit(:plan, :proposer_id, :appointment, :location)
	end
end