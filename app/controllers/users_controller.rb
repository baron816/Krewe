class UsersController < ApplicationController
	before_action :set_user, only: [:public_profile, :edit]

	def index
		@users = User.all
	end

	def show
		@user = User.includes(:groups).find(params[:id])
		redirect_to user_path(current_user) unless @user == current_user
	end

	def public_profile
	end

	def edit
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
		current_user.find_or_create_group
		redirect_to user_path(current_user)
	end

	private
	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:name, :email, :address, :password, :password_confirmation, :street, :city, :state, :birth_day, :birth_month, :birth_year, :category)
	end
end