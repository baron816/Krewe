class SessionsController < ApplicationController

	def login
		@user = User.find_by(email: user_params[:email].downcase).try(:authenticate, user_params[:password])

		if @user
			log_in(@user)
			redirect_to root_path
		else
			flash[:error] = "Email or Password not found"
			render :login
		end
	end

	def create
		auth = request.env["omniauth.auth"]

		if auth.provider == "facebook"
			user = User.find_by(provider: "facebook", uid: auth.uid)
		else
			user = User.find_by(email: auth.info.email)
		end

		if user
			log_in(user)
			redirect_to(root_path)
		else
			user = User.create_with_omniauth(auth)
			log_in(user)
			redirect_to(complete_sign_up_users_path)
		end
	end

	def destroy
		log_out
		redirect_to get_started_path
	end

	private
	def user_params
	  params.require(:session).permit(:email, :password)
	end
end
