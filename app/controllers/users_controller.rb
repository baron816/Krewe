class UsersController < ApplicationController
	before_action :set_user, only: [:edit, :update, :public_profile, :join_group, :destroy]
	before_action :user_logged?, only: [:update, :edit]

	def show
		@user_show = User.includes(:groups).friendly.find(params[:id])
		message_root_redirect("You do not have access to go there.") unless @user_show == current_user
	end

	def public_profile
		if current_user.is_friends_with?(@user) || current_user == @user
			@user = UserPublicProfile.new(@user, current_user, params[:page])
		else
			message_root_redirect("You do not know that person.")
		end
	end

	def edit
		respond_to do |format|
		  format.html
		  format.js
		end
	end

	def update
		if @user == current_user
			if @user.update(user_params)
				redirect_to user_path(@user)
			else
				render :edit
			end
		else
			message_root_redirect("You do not have access to do that.")
		end
	end

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
			redirect_to user_path(@user)
		else
			render :new
		end
	end

	def join_group
	  if @user.under_group_limit?
	  	new_group = @user.find_or_create_group
			redirect_to group_path(new_group)
	  end
	end

	def destroy
		if @user == current_user
			group = @user.degree_groups(1).take
			@user.destroy
			group.check_space(@user)
			redirect_to new_survey_path(params: { email: @user.email })
		else
			message_root_redirect("You do not have access to do that.")
		end
	end

	private
	def set_user
		@user = User.friendly.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:name, :email, :address, :password, :password_confirmation, :address, :category, :age_group, :latitude, :longitude)
	end
end
