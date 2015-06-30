class ActivitiesController < ApplicationController
	def create
		@activity = Group.find(params[:group_id]).activities.new(activity_params)
		@activity.appointment -= Time.now.utc_offset

		@activity.save
		redirect_to(@activity.group)
	end

	def add_user
		@activity = Activity.find(params[:activity_id])

		@activity.users << current_user

		redirect_to(current_user)
	end

	def show
		@activity = Activity.find(params[:id])
		@hash = Gmaps4rails.build_markers([@activity]) do |activity, marker|
			marker.lat activity.latitude
			marker.lng activity.longitude
		end
	end

	private
	def activity_params
		params.require(:activity).permit(:plan, :proposer_id, :appointment, :location)
	end
end