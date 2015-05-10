class GroupsController < ApplicationController
	def index
		@groups = Group.all
	end

	def show
		@message = Message.new
		@group = Group.includes(:users).find(params[:id])
		@messages = Message.paginate(page: params[:page], per_page: 5)
	end
end