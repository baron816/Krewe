class DropUserVotesController < ApplicationController
	def create
		@group = Group.find(params[:group_id])
		@user = User.find(params[:user_id])
		@vote = @group.drop_user_votes.new(user: @user, voter: current_user)
		@vote.save
		@group.kick_user(@user)
		redirect_to @group
	end

	def destroy
		@vote = DropUserVote.find(params[:id])
		@vote.destroy
		redirect_to Group.find(params[:group_id])
	end
end