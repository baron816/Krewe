class SessionsController < ApplicationController
	def new
		respond_to do |format|
		  format.html
		  format.js
		end
	end

	def create
		@user = User.find_by(email: user_params[:email].downcase).try(:authenticate, user_params[:password])

		if @user
			log_in(@user)
			redirect_to user_path(@user)
		else
			flash[:error] = "Email or Password not found"
			render :new
		end
	end

	def destroy
		log_out
		redirect_to root_path
	end

	private
	def user_params
		params.require(:session).permit(:email, :password)
	end
end
