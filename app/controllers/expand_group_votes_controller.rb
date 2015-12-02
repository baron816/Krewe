class ExpandGroupVotesController < ApplicationController
  before_action :set_group

  def create
    @expand_vote = @group.expand_group_votes.new(voter_id: current_user.id)
    authorize! :vote, @expand_vote

    @expand_vote.save

    if @group.voted_to_expand? && @group.ripe_for_expansion?
      new_group = ExpandGroup.new(@group).expand_group

      return redirect_to group_path(new_group) if new_group
    end

    respond_to do |format|
      format.html { redirect_to @group }
      format.js
    end
  end

  def destroy
    @vote = ExpandGroupVote.find(params[:id])
    @vote.destroy
    respond_to do |format|
      format.html { redirect_to @group }
      format.js
    end
  end

  private
  def set_group
    @group = Group.friendly.find(params[:group_id])
  end
end
