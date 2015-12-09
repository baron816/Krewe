class HomeController < ApplicationController
	def index
		prepare_meta_tags
	end

	def faq
		prepare_meta_tags
	end

	def about
	  prepare_meta_tags
	end

	def privacy_policy
	end

	def terms_of_service
	end

	def admin_dash
	  @admin = AdminDash.new(params[:page])
		authorize! :read, @admin
	end
end
