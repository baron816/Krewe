class UsersController < ApplicationController
	before_action :set_user, only: [:edit, :update, :join_group, :destroy, :new]

	def show
		@user_show = current_user
		return redirect_to get_started_path unless current_user
		return redirect_to new_user_path unless current_user.sign_up_complete?
	end

	def personal_messages
		@user = User.friendly.find(params[:id])
		authorize! :personal_messages, @user
		@user = UserPersonalMessageShow.new(@user, current_user, params[:page])
	end

	def edit
		respond_to do |format|
		  format.html
		  format.js
		end
	end

	def new
		authorize! :read, @user
	end

	def update
		if @user.update(user_params)
			redirect_to root_path
		elsif @user.sign_up_complete?
			render :edit
		else
			render :new
		end
	end

	def join_group
	  if @user.under_group_limit?
	  	new_group = FindGroup.new(@user).find_or_create
			redirect_to group_path(new_group)
	  end
	end

	def destroy
		group = @user.degree_groups(1).take
		@user.destroy
		group.users_empty? ? group.destroy : group.check_space(@user)
		redirect_to new_survey_path(params: { email: @user.email })
	end

	private
	def set_user
		@user = current_user
	end

	def user_params
		params.require(:user).permit(g:address, :category, :age_group, :latitude, :longitude, :sign_up_complete, notification_settings: [:join, :proposal, :mention, :personal, :expand])
	end
end
