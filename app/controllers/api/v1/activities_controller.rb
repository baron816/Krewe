class Api::V1::ActivitiesController < ApplicationController
  include Authenticable

  before_action :set_activity, except: :create
  before_action :authenticate_with_token!, only: [:create, :update]
  before_action :set_group, only: :create

  def show
    render json: @activity
  end

  def create
    activity = @group.activities.new(activity_params)

    if activity.save
      render json: activity, status: 201
    else
      render json: { errors: activity.errors }, status: 422
    end
  end

  def update
    if @activity.update(activity_params)
      render json: @activity, status: 200
    else
      render json: { errors: @activity.errors }, status: 422
    end
  end

  def add_user
    @activity.users << current_user

    render json: @activity, status: 201
  end

  def remove_user
    @activity.users.delete(current_user)

    head 204
  end

  private
  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_group
    @group = Group.friendly.find(params[:group_id])
  end

  def activity_params
    params.require(:activity).permit(:plan, :proposer_id, :group_id, :appointment, :location, :latitude, :longitude)
  end
end
