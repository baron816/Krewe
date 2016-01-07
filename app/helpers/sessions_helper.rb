module SessionsHelper
	def log_in(user, params = {})
		if params[:remember_me]
			cookies.permanent.signed[:auth_token] = user.auth_token
		else
			cookies.signed[:auth_token] = user.auth_token
		end
	end

	def log_out
		cookies.delete(:auth_token)
		@current_user = nil
	end

	def current_user
		@current_user ||= User.find_by(auth_token: cookies.signed[:auth_token]) if cookies.signed[:auth_token]
	end
end
