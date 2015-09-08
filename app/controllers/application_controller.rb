class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :user_logged?, except: [:new, :index, :create, :edit, :update]

  def user_logged?
    redirect_to root_path, notice: "Please log in first." unless current_user
  end
end
