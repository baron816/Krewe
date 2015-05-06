class SessionsController < ApplicationController
	def new
		
	end

	def create
		@user = User.find_by(email: user_params[:email]).try(:authenticate, user_params[:password])
		
		if @user
			log_in(@user)
			redirect_to :back
		else
			render :new
		end
	end

	private

	def user_params
		params.require(:session).permit(:email, :password)
	end
end