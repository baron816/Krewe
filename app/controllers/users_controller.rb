class UsersController < ApplicationController
	before_action :set_user, only: [:edit, :update, :join_group, :destroy, :complete_sign_up]

	def new
		@user = User.new
	  respond_to do |format|
	    format.html
	    format.js
	  end
	end

	def create
	  @user = User.new(user_params)

		if @user.save
			log_in(@user)
			redirect_to complete_sign_up_users_path
		else
			render :new
		end
	end

	def show
		@user_show = current_user
		return redirect_to get_started_path unless current_user
		return redirect_to complete_sign_up_users_path unless current_user.sign_up_complete?
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

	def complete_sign_up
		authorize! :read, @user
	end

	def update
		sign_up_complete = @user.sign_up_complete?

		if @user.update(user_params)
			flash[:welcome] = @user.sign_up_complete? != sign_up_complete
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
		if group
			group.users_empty? ? group.destroy : group.check_space(@user)
		end
		redirect_to new_survey_path(params: { email: @user.email })
	end

	private
	def set_user
		@user = current_user
	end

	def user_params
		params.require(:user).permit(:name, :address, :email, :password, :category, :age_group, :latitude, :longitude, :sign_up_complete, notification_settings: [:join, :proposal, :mention, :personal, :expand])
	end
end
