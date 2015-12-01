class HomeController < ApplicationController
	def index
	end

	def faq
	end

	def admin_dash
	  @admin = AdminDash.new
		authorize! :read, @admin
	end
end
