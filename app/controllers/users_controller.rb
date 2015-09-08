class UsersController < ApplicationController
	before_action :set_user, only: [:edit, :update, :public_profile, :add_group]
	before_action :user_logged?, only: [:update, :edit]

	def show
		@user = User.includes(:groups).find(params[:id])
		check_user
	end

	def public_profile
		redirect_to root_path unless current_user.friends.include?(@user)
		current_user.dismiss_personal_notifications_from_user(@user)
		@user = UserPublicProfile.new(@user, current_user)
	end

	def edit
		check_user
	end

	def update
		if @user.update(user_params)
			redirect_to user_path(@user)
		else
			render :edit
		end
	end

	def new
		@user = User.new
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

	private
	def set_user
		@user = User.find(params[:id])
	end

	def check_user
		redirect_to root_path, notice: "You don't have access to go there" unless @user == current_user
	end

	def user_params
		params.require(:user).permit(:name, :email, :address, :password, :password_confirmation, :street, :city, :state, :category, :latitude, :longitude)
	end
end
