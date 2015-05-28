class ActivitiesController < ApplicationController

	def create
		@activity = Activity.new(activity_params)

		@activity.save
		redirect_to group_path(@activity.group)
	end

	private
	def activity_params
		params.require(:activity).permit(:plan)
	end
end