class NewslettersController < ApplicationController
  def new
  end

  def create
    email = params[:newsletter][:email]
    begin
      RestClient.post("https://api:key-#{ENV['MAILGUN_API_KEY']}" \
                  "@api.mailgun.net/v3/lists/thelist@mg.gokrewe.com/members",
                  subscribed: true,
                  address: email)

      redirect_to root_path, notice: "Awesome, #{email} is now signed up for the Krewe newsletter."
    rescue
      redirect_to root_path, notice: "I think you signed up already."
    end
  end
end
