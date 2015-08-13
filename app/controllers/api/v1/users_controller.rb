class Api::V1::UsersController < ApplicationController
  include Authenticable

  before_action :set_user, only: [:public_profile, :update, :add_group, :show]
  respond_to :json

  def show
    render json: @user
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def public_profile
    render json: { messages: PersonalMessage.users_messages(first_user: @user, second_user: current_user) }
  end

  def update
    if @user.update(user_params)
      render json: @user, status: 200
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def add_group
    if @user.under_group_limit?
      group = @user.find_or_create_group
      render json: group
    else
      render json: { errors: "Group limit already reached" }, status: 422
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
		params.require(:user).permit(:name, :email, :address, :password, :password_confirmation, :street, :city, :state, :category, :latitude, :longitude)
	end
end
