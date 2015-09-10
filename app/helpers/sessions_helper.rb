module SessionsHelper
	def log_in(user)
		if params[:remember_me]
			cookies.permanent[:auth_token] = user.auth_token
		else
			cookies[:auth_token] = user.auth_token
		end
		user.update_sign_in(request.remote_ip)
	end

	def log_out
		cookies.delete(:auth_token)
		@current_user = nil
	end

	def current_user
		@current_user ||= User.find_by(auth_token: cookies[:auth_token]) if cookies[:auth_token]
	end

	def user_notifications
	  @user_notifications ||= UserNotification.new(current_user)
	end
end
