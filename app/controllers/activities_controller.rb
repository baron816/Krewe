class ActivitiesController < ApplicationController

	def create
		@activity = Activity.new(activity_params)
		@activity.appointment -= Time.now.utc_offset

		@activity.save
		redirect_to(@activity.group)
	end

	def add_user
		@activity = Activity.find(params[:activity_id])

		@activity.users << current_user

		redirect_to(current_user)
	end

	private
	def activity_params
		params.require(:activity).permit(:plan, :proposer_id, :group_id, :appointment)
	end
end