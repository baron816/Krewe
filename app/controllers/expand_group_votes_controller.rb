class ExpandGroupVotesController < ApplicationController
  before_action :set_group

  def create
    ExpandGroupVote.create(group_id: @group.id, voter_id: current_user.id)
    redirect_to @group
  end

  def destroy
    @vote = ExpandGroupVote.find(params[:id])
    @vote.destroy
    redirect_to @group
  end

  private
  def set_group
    @group = Group.find(params[:group_id])
  end
end
