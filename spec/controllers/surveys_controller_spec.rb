require "rails_helper"

describe SurveysController do
  describe "GET #new" do
    before do
      get :new
    end

    it "assigns a new survey" do
      expect(assigns[:survey]).to be_a_new(Survey)
    end

    it "renders the template" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "when successful" do
      before do
        @survey_attributes = {reasons: ["didn't like it", "too confusing"], email: "bob@mail.com"}
      end

      it "creates a survey" do
        expect { post :create, survey: @survey_attributes }.to change(Survey, :count).by(1)
      end

      it "redirects to root" do
        post :create, survey: @survey_attributes
        expect(response).to redirect_to root_path
      end
    end
  end
end
