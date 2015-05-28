class GroupsController < ApplicationController
	def index
		@groups = Group.all
	end

	def show
		@group = Group.includes(:users, :notifications).find(params[:id])
		redirect_to user_path(current_user) unless @group.users.include?(current_user)
		@group.dismiss_notifications(current_user)
		@message = Message.new
		@messages = Message.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
		@activity = Activity.new
	end

	def drop_user
		@group = Group.includes(:users).find(params[:id])
		@group.drop_user(current_user)
		redirect_to user_path(current_user)
	end
end