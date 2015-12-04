class HomeController < ApplicationController
	def index
		prepare_meta_tags
	end

	def faq
		prepare_meta_tags
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
