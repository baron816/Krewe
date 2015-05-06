class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit]

	def index
		@users = User.all
	end

	def show
	end

	def edit
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save
			redirect_to user_path(@user)
		else
			render :new
		end
	end

	private
	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:name, :email, :address, :password, :password_confirmation)
	end
end