class Api::V1::ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :update, :add_user, :remove_user]

  def show
    render json: @activity
  end

  def create
    activity = Activity.new(activity_params)

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

  private
  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:plan, :proposer_id, :group_id, :appointment, :location, :latitude, :longitude)
  end
end
