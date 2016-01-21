require 'rails_helper'

describe BetaCodesController do
  describe "#GET new" do
    context "user logged in" do
      let(:user) { create(:user_home) }
      before do
        log_in(user)
        get :new
      end

      it "redirects to root" do
        expect(response).to redirect_to(root_path)
      end

      it "doesn't create a betacode" do
        expect(assigns[:beta_code]).to be_nil
      end
    end

    context "no user logged in" do
      before do
        get :new
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "initializes a new beta code" do
        expect(assigns[:beta_code]).to be_a_new(BetaCode)
      end
    end
  end

  describe "#POST create" do
    it "creates a new beta code" do
      expect{ post :create, beta_code: { email: "baron@mail.com" } }.to change(BetaCode, :count).by(1)
    end

    context "after create" do
      before do
        post :create, beta_code: { email: "baron@mail.com" }
      end

      it "redirects to landing page" do
        expect(response).to redirect_to(get_started_path)
      end

      it "renders a notice" do
        expect(flash.notice).to eq("Awesome, we sent you an email. Use that to finish signing up.")
      end
    end
  end
end
