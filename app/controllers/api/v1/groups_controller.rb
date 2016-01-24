class Api::V1::GroupsController < ApiController
  respond_to :json
  before_action :set_group

  def show
    render json: @group
  end

  def drop_user
    DropUser.new(@group, current_user).drop
    head 204
  end

  private
  def set_group
    @group = Group.friendly.find(params[:id])
  end
end
