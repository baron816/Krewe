class Api::V1::GroupsController < ApplicationController
  respond_to :json

  def show
    render json: Group.find(params[:id])
  end
end
