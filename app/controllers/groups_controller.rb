class GroupsController < ApplicationController
	def index
		@groups = Group.all
	end

	def show
		@group = Group.includes(:users).find(params[:id])
	end
end