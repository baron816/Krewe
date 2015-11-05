class ApiController < ActionController::Base
  protect_from_forgery with: :null_session
  include Authenticable

  before_action :user_logged?, except: [:new, :index, :create, :edit, :update]

  def user_logged?
    head 403 unless user_signed_in?
  end
end
