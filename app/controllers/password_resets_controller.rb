class PasswordResetsController < ApplicationController
	before_action :set_user, only: [:edit, :update]
	before_action :check_expiration, only: [:edit, :update]

	def new
	end

	def create
		@user = User.find_by(email: params[:password_reset][:email])

		if @user
			@user.send_password_reset
			redirect_to root_path
		else
			flash.now[:danger] = "Email Address not found"
			render :new
		end
	end

	def edit
		
	end

	def update
		if params[:user][:password].empty?
			render :edit
		elsif @user.update(user_params)
			log_in(@user)
			redirect_to @user
		else
			render :edit
		end
	end

	private
	def set_user
		@user = User.find_by(email: params[:email])
	end

	def user_params
		params.require(:user).permit(:password, :password_confirmation)
	end

	def check_expiration
		if @user.password_reset_expired?
			redirect_to new_password_reset_url
		end
	end
end