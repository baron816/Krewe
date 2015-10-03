class Api::V1::GroupsController < ApplicationController
  include Authenticable

  respond_to :json
  before_action :set_group

  def show
    render json: @group
  end

  def drop_user
    @group.drop_user(current_user)
    head 204
  end

  private
  def set_group
    @group = Group.friendly.find(params[:id])
  end
end
