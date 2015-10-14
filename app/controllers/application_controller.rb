class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :user_logged?, except: [:new, :index, :create, :edit, :update]

  def user_logged?
    message_root_redirect("Please log in first.") unless current_user
  end

  def message_root_redirect(message)
    redirect_to root_path, notice: message
  end
end
