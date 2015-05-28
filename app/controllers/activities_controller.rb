class ActivitiesController < ApplicationController

	def create
		@activity = Activity.new(activity_params)

		@activity.save
		redirect_to(@activity.group)
	end

	private
	def activity_params
		params.require(:activity).permit(:plan, :proposer_id, :group_id, :appointment)
	end
end