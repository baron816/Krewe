class ActivitiesController < ApplicationController
	before_action :set_activity, only: [:edit, :update, :add_user, :remove_user, :show]
	before_action :user_logged?, only: [:create, :update, :edit, :new]
	before_action :set_group, only: [:create, :new]

	def create
		@activity = @group.activities.new(activity_params)

		if @activity.save
			@activity.users << @activity.proposer
			redirect_to activity_path(@activity)
		else
			render :new
		end
	end

	def add_user
		unless @activity.user_going?(current_user)
			@activity.users << current_user
			@activity.check_attendance
			respond_to do |format|
				format.html { redirect_to activity_path(@activity) }
				format.js
			end
		else
			redirect_to activity_path(@activity)
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
		if @activity.update(activity_params) && @activity.proposed_by?(current_user)
			@activity.send_notifications("ActivityUpdate")
			redirect_to activity_path(@activity)
		else
			redirect_to edit_activity_path(@activity), flash: { errors: @activity.errors.full_messages }
		end
	end

	def show
		@activity = ActivityShow.new(@activity, current_user)

		redirect_to root_path unless @activity.group_includes_user?(current_user)
		current_user.dismiss_activity_notification(@activity.activity)
	end

	def new
		@activity = Activity.new
	end

	private
	def set_activity
		@activity = Activity.find(params[:id])
	end

	def set_group
		@group = Group.friendly.find(params[:group_id])
	end

	def activity_params
		params.require(:activity).permit(:plan, :appointment, :location, :latitude, :longitude).merge(proposer_id: current_user.id)
	end
end
