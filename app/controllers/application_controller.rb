class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :set_notifications, only: [:show, :new, :edit, :public_profile, :index]

  def set_notifications
  	@notifications = current_user.notifications if current_user
  end
end
