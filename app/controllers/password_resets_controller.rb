class PasswordResetsController < ApplicationController
	before_action :set_user, only: [:edit, :update]

	def new
	end

	def create
		email = params[:password_reset][:email]
		@user = User.find_by(email: email.downcase)

		user_password_reset.send_password_reset if @user

		redirect_to root_path, notice: "An email was just sent to #{email} to reset your password. It will expire in one hour."
	end

	def edit
		return redirect_to get_started_path unless @user
		check_expiration
	end

	def update
		check_expiration
		if params[:user][:password].empty? || params[:user][:password_confirmation].empty?
			flash.now[:danger] = "Password can't be empty"
			render :edit
		elsif @user.update(user_params)
			log_in(@user)
			redirect_to root_path
		else
			render :edit
		end
	end

	private
	def set_user
		@user = User.find_by(password_reset_token: params[:id])
	end

	def user_params
		params.require(:user).permit(:password, :password_confirmation)
	end

	def check_expiration
		if user_password_reset.password_reset_expired?
			flash[:danger] = "Password reset has expired. Please enter your email again."
			redirect_to new_password_reset_url
		end
	end

	def user_password_reset
	  @user_password_reset ||= UserPasswordReset.new(@user)
	end
end
