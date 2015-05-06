class SessionsController < ApplicationController
	def new
	end

	def create
		@user = User.find_by(email: user_params[:email]).try(:authenticate, user_params[:password])
		
		if @user
			log_in(@user)
			redirect_to root_path
		else
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