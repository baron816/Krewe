class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

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
end
