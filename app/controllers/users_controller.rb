class UsersController < ApplicationController
	before_action :set_user, only: [:edit, :update, :public_profile, :join_group, :destroy]
	before_action :user_logged?, only: [:update, :edit]

	def show
		@user = User.includes(:groups).friendly.find(params[:id])
		check_user
	end

	def public_profile
		redirect_to root_path unless current_user.friends.include?(@user)
		current_user.dismiss_personal_notifications_from_user(@user)
		@user = UserPublicProfile.new(@user, current_user, params[:page])
	end

	def edit
		check_user
	end

	def update
		if @user.update(user_params)
			redirect_to user_path(@user, params: {hello: "hey"})
		else
			render :edit
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
		group = @user.degree_groups(1).take
		@user.destroy
		group.check_space(@user)
		redirect_to new_survey_path(params: { email: @user.email })
	end

	private
	def set_user
		@user = User.friendly.find(params[:id])
	end

	def check_user
		redirect_to root_path, notice: "You don't have access to go there" unless @user == current_user
	end

	def user_params
		params.require(:user).permit(:name, :email, :address, :password, :password_confirmation, :address, :category, :latitude, :longitude)
	end
end
