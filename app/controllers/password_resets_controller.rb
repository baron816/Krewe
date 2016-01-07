class PasswordResetsController < ApplicationController
	before_action :set_user, only: [:edit, :update]
	before_action :check_expiration, only: [:edit, :update]

	def new
	end

	def create
		email = params[:password_reset][:email]
		@user = User.find_by(email: email.downcase)

		@user.send_password_reset if @user

		redirect_to root_path, notice: "An email was just sent to #{email} to reset your password. It will expire in one hour."
	end

	def edit

	end

	def update
		if params[:user][:password].empty? || params[:user][:password_confirmation].empty?
			flash.now[:danger] = "Password can't be empty"
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
			flash[:danger] = "Password reset has expired."
			redirect_to new_password_reset_url
		end
	end
end
