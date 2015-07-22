class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :set_notifications, only: [:show, :new, :edit, :public_profile, :index]
  before_action :user_logged?, except: [:new, :index, :create, :edit, :update]

  def set_notifications
  	@notifications = current_user.notifications.includes(:poster) if current_user
  end

  def user_logged?
    redirect_to root_path unless current_user
  end
end
