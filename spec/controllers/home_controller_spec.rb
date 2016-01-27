require "rails_helper"

describe HomeController do
  describe "#GET landing" do
    context "user logged in" do
      let(:user) { create(:user_home) }
      before do
        log_in(user)
        get :landing
      end

      it "redirects to root path" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "no logged user" do
      before do
        get :landing
      end

      it "renders the template" do
        expect(response).to render_template(:landing)
      end
    end
  end

  describe "#GET faq" do
    before do
      get :faq
    end

    it "renders the template" do
      expect(response).to render_template(:faq)
    end
  end

  describe "#GET about" do
    before do
      get :about
    end

    it "renders the template" do
      expect(response).to render_template(:about)
    end
  end

  describe "#GET privacy_policy" do
    before do
      get :privacy_policy
    end

    it "renders the template" do
      expect(response).to render_template(:privacy_policy)
    end
  end

  describe "#GET terms_of_service" do
    before do
      get :terms_of_service
    end

    it "renders the template" do
      expect(response).to render_template(:terms_of_service)
    end
  end

  describe "#GET admin_dash" do
    context "not an admin" do
      let(:user) { create(:user_home)}
      before do
        log_in(user)
        get :admin_dash
      end

      it "redirect to root" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "admin logged in" do
      let(:user) { create(:baron_admin)}
      before do
        log_in(user)
        get :admin_dash
      end

      it "renders the template" do
        expect(response).to render_template(:admin_dash)
      end

      it "sets an admin dash instance" do
        expect(assigns[:admin]).to be_a(AdminDash)
      end
    end
  end
end
