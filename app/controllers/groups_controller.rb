class GroupsController < ApplicationController
	def index
		@groups = Group.all
	end

	def show
		@message = Message.new
		@group = Group.includes(:users).find(params[:id])
		@messages = Message.paginate(page: params[:page], per_page: 5)
	end

	def drop
		@group = Group.includes(:users).find(params[:id])
		@group.drop_user(current_user)
		redirect_to user_path(current_user)
	end
end