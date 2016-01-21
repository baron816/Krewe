class DropUserVotesController < ApplicationController
	def create
		group = Group.friendly.find(params[:group_id])
		user = User.friendly.find(params[:user_id])

		vote = group.drop_user_votes.new(user: user, voter: current_user)
		authorize! :vote, vote
		vote.save!

		respond_to do |format|
			format.html { redirect_to group }
			format.js
		end
	end

	def destroy
		vote = DropUserVote.find(params[:id])

		vote.destroy!
		respond_to do |format|
			format.html { redirect_to vote.group }
			format.js
		end
	end
end
