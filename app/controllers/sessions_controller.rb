class SessionsController < ApplicationController

	def create
		auth = request.env["omniauth.auth"]
		user = User.where(provider: auth["provider"], uid: auth["uid"]).first

		if user
			log_in(user)
			redirect_to(root_path)
		else
			user = User.create_with_omniauth(auth)
			log_in(user)
			redirect_to(new_user_path)
		end
	end

	def destroy
		log_out
		redirect_to get_started_path
	end

	private
	def user_params
		params.require(:session).permit(:email, :password, :remember_me)
	end
end
