class UsersController < ApplicationController
	before_action :set_user, only: [:public_profile, :update, :edit, :add_group]

	def show
		@user = User.includes(:groups, :notifications).find(params[:id])
		check_user
	end

	def public_profile
		redirect_to root_path unless current_user.friends.include?(@user)
		@personal_messages = PersonalMessage.users_messages(first_user: @user, second_user: current_user).paginate(page: params[:page], per_page: 5)
		@personal_message = PersonalMessage.new
		current_user.dismiss_personal_notifications(@user)
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

	def add_group
		@user.find_or_create_group
		redirect_to user_path(@user)
	end

	private
	def set_user
		@user = User.find(params[:user_id])
	end

	def check_user
		redirect_to root_path unless @user == current_user
	end

	def user_params
		params.require(:user).permit(:name, :email, :address, :password, :password_confirmation, :street, :city, :state, :birth_day, :birth_month, :birth_year, :category)
	end
end