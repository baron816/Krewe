class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :set_cache_headers

  rescue_from "AccessGranted::AccessDenied" do |exception|
    redirect_to root_path, notice: "You do not have permission to do that."
  end

  def message_root_redirect(message)
    redirect_to root_path, notice: message
  end

  def prepare_meta_tags(options = {})
    site = "Krewe"
    description = "Krewe forms small, local social groups to help build your social network"
    current_url = request.url

    defaults = {
      site: site,
      description: description,
      keywords: %w[social networking groups friends relationships]
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
