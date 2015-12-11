class ActivitiesController < ApplicationController
	before_action :set_activity, except: [:new, :create]
	before_action :set_group, only: [:create, :new]

	def create
		authorize! :read, @group
		@activity = @group.activities.new(activity_params)

		if @activity.save
			@activity.users << @activity.proposer
			redirect_to activity_path(@activity)
		else
			render :new
		end
	end

	def add_user
		authorize! :read, @activity.group

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
		authorize! :read, @activity.group
		@activity.users.delete(current_user)
		@activity.check_attendance
		redirect_to current_user
	end

	def edit
		authorize! :update, @activity
	end

	def update
		authorize! :update, @activity
		if @activity.update(activity_params)
			redirect_to activity_path(@activity)
		else
			redirect_to edit_activity_path(@activity), flash: { errors: @activity.errors.full_messages }
		end
	end

	def show
		@activity = ActivityShow.new({activity: @activity, user: current_user, page: params[:page]})
		authorize! :read, @activity.group

		current_user.dismiss_activity_notification(@activity.activity)
	end

	def new
		authorize! :read, @group
		@activity = Activity.new
	end

	def destroy
	  authorize! :update, @activity

		@activity.destroy
		redirect_to current_user
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
