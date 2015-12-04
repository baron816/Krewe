class HomeController < ApplicationController
	def index
	end

	def faq
	end

	def privacy_policy
	end

	def terms_of_service
	end

	def admin_dash
	  @admin = AdminDash.new
		authorize! :read, @admin
	end
end
