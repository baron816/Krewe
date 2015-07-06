class ActivitiesController < ApplicationController
	def create
		@activity = Group.find(params[:group_id]).activities.new(activity_params)
		@activity.appointment -= Time.now.utc_offset

		current_user.activities << @activity

		if @activity.save
			redirect_to group_activity_path(@activity.group, @activity)
		else
			@group = Group.includes(:users, :notifications, :activities).find(params[:group_id])
			@message = Message.new
			@messages = @group.messages.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
			render 'groups/show'
		end
	end

	def add_user
		@activity = Activity.find(params[:activity_id])

		@activity.users << current_user

		redirect_to group_activity_path(@activity.group, @activity)
	end

	def show
		@activity = Activity.find(params[:id])
		@hash = Gmaps4rails.build_markers([@activity]) do |activity, marker|
			marker.lat activity.latitude
			marker.lng activity.longitude
		end
	end

	def new
		@group = Group.find(params[:group_id])
		@activity = Activity.new
	end

	private
	def activity_params
		params.require(:activity).permit(:plan, :proposer_id, :appointment, :location)
	end
end