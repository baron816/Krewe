class ActivitiesController < ApplicationController
	before_action :set_activity, only: [:edit, :update, :add_user, :remove_user]
	before_action :user_logged?, only: [:create, :update, :edit, :new]

	def create
		@activity = Activity.new(activity_params)

		if @activity.save
			@activity.users << @activity.proposer
			redirect_to activity_path(@activity)
		else
			redirect_to group_path(@activity.group), flash: { errors: @activity.errors.full_messages }
		end
	end

	def add_user
		@activity.users << current_user
		@activity.check_attendance
		respond_to do |format|
			format.html { redirect_to activity_path(@activity) }
			format.js
		end
	end

	def remove_user
		@activity.users.delete(current_user)
		@activity.check_attendance
		redirect_to current_user
	end

	def edit
	end

	def update
		@group = @activity.group

		if @activity.update(activity_params) && @activity.proposed_by?(current_user)
			@activity.send_notifications("ActivityUpdate")
			redirect_to activity_path(@activity)
		else
			redirect_to edit_activity_path(@activity), flash: { errors: @activity.errors.full_messages }
		end
	end

	def show
		@activity = Activity.includes(:group).find(params[:id])
		redirect_to root_path unless @activity.group_includes_user?(current_user)
		current_user.dismiss_activity_notification(@activity)
	end

	def new
		@activity = Activity.new
	end

	private
	def set_activity
		@activity = Activity.find(params[:id])
	end

	def activity_params
		params.require(:activity).permit(:plan, :proposer_id, :group_id, :appointment, :location, :latitude, :longitude)
	end
end
