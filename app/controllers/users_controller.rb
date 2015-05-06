class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit]

	def index
		@users = User.all
	end

	def show
	end

	def edit
	end

	def create
		@user = User.new(user_params)

		if @user.save
			redirect_to user_path(@user)
		else
			redirect_to new_user_path
		end
	end

	def new
		@user = User.new
	end

	private
	def set_user
		@user = User.find(params[:id])
	end
end