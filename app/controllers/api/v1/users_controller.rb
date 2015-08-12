class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: :public_profile
  respond_to :json

  def show
    render json: User.find(params[:id])
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

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
		params.require(:user).permit(:name, :email, :address, :password, :password_confirmation, :street, :city, :state, :category, :latitude, :longitude)
	end
end
