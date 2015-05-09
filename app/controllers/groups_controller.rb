class GroupsController < ApplicationController
	def index
		@groups = Group.all
	end

	def show
		@message = Message.new
		@group = Group.includes(:users, :messages).find(params[:id])
	end
end