class ExpandGroupVotesController < ApplicationController
  before_action :set_group

  def create
    @expand_vote = ExpandGroupVote.create(group_id: @group.id, voter_id: current_user.id)
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
    @group = Group.find(params[:group_id])
  end
end
