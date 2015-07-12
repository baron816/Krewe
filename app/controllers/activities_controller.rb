class ActivitiesController < ApplicationController
	before_action :set_group, only: [:create, :new, :edit]
	before_action :set_activity_with_activity_id, only: [:add_user, :remove_user]
	before_action :set_activity, only: [:show, :edit, :update]

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
		respond_to do |format|
			format.html { redirect_to group_activity_path(@activity.group, @activity) }
			format.js
		end
	end

	def remove_user
		@activity.users.delete(current_user)

		redirect_to current_user
	end

	def edit
	end

	def update
		@group = @activity.group

		if @activity.update(activity_params) && @activity.proposed_by?(current_user)
			Message.create(group_id: @group.id, user_id: current_user.id, content: @activity.message_maker)
			redirect_to group_activity_path(@group, @activity)
		else
			redirect_to edit_group_activity_path(@group, @activity), flash: { errors: @activity.errors.full_messages }
		end
	end

	def show
		@notifications.dismiss_activity_notification(@activity)
	end

	def new
		@activity = Activity.new
	end

	private
	def set_activity_with_activity_id
		@activity = Activity.find(params[:activity_id])
	end

	def set_activity
		@activity = Activity.find(params[:id])
	end

	def set_group
		@group = Group.find(params[:group_id])
	end

	def activity_params
		params.require(:activity).permit(:plan, :proposer_id, :appointment, :location)
	end
end
