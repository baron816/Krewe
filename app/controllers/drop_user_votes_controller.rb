class DropUserVotesController < ApplicationController
	def create
		@group = Group.find(params[:group_id])
		@user = User.find(params[:user_id])
		@vote = @group.drop_user_votes.new(user: @user, voter: current_user)
		@vote.save
		redirect_to @group
	end
end