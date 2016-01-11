class BetaCodesController < ApplicationController
  def new
    return redirect_to current_user if current_user

    @beta_code = BetaCode.new
  end

  def create
    @beta_code = BetaCode.new(beta_params)

    if @beta_code.save
      redirect_to get_started_path, notice: "Awesome, we sent you an email. Use that to finish signing up."
    else
      render :new
    end
  end

  private
  def beta_params
    params.require(:beta_code).permit(:email)
  end
end
