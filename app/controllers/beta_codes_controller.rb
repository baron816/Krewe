class BetaCodesController < ApplicationController
  def new
    return redirect_to current_user if current_user

    @beta_code = BetaCode.new
  end

  def create
    @beta_code = BetaCode.new(beta_params)

    if @beta_code.save
      UserMailer.delay.beta_code(@beta_code)

      redirect_to root_path, notice: "Thanks for signing up for the beta. Keep an eye out for an email."
    else
      render :new
    end
  end

  private
  def beta_params
    params.require(:beta_code).permit(:email)
  end
end
