class ActivitiesController < ApplicationController
	before_action :set_group, only: [:create, :new]

	def create
		@activity = @group.activities.new(activity_params)

		if @activity.save
			current_user.activities << @activity
			redirect_to group_activity_path(@group, @activity)
		else
			redirect_to group_path(@group), flash: { error: @activity.errors.full_messages }
		end
	end

	def add_user
		@activity = Activity.find(params[:activity_id])

		@activity.users << current_user

		redirect_to group_activity_path(@activity.group, @activity)
	end

	def show
		@activity = Activity.find(params[:id])
		current_user.dismiss_activity_notification(@activity)
		@hash = Gmaps4rails.build_markers([@activity]) do |activity, marker|
			marker.lat activity.latitude
			marker.lng activity.longitude
		end
	end

	def new
		@activity = Activity.new
	end

	private
	def set_group
		@group = Group.find(params[:group_id])
	end

	def activity_params
		params.require(:activity).permit(:plan, :proposer_id, :appointment, :location)
	end
end