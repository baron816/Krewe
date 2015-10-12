class SurveysController < ApplicationController
  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)

    if @survey.save
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def survey_params
    params.require(:survey).permit(:email, reasons: [])
  end
end
