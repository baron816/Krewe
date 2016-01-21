require 'rails_helper'

describe SessionsController do
  let!(:user) { create(:baron) }

  describe "#GET new" do
    before do
      get :new
    end

    it "renders the new session form" do
      expect(response).to render_template(:new)
    end
  end

  describe "#POST create" do
    context "user enters correct credentials and don't remember" do
      before do
        post :create, session: { email: "baron@mail.com", password: '12ab34CD', remember_me: "0" }
      end

      it "finds the right user" do
        expect(assigns[:user]).to eq(user)
      end

      it "redirects to the root" do
        expect(response).to redirect_to(root_path)
      end

      it "sets cookies" do
        expect(cookies.signed['auth_token']).to eq(user.auth_token)
      end
    end

    context "correct credentials and permanent cookies" do
      before do
        post :create, session: { email: "baron@mail.com", password: '12ab34CD', remember_me: "1" }
      end

      it "sets permanent cookies" do
        expect(cookies.permanent.signed['auth_token']).to eq(user.auth_token)
      end
    end

    context "incorrect credentials" do
      before do
        post :create, session: { email: "baron@mail.com", password: "aWrongPassword", remember_me: "0"}
      end

      it "flashes an error message" do
        expect(flash[:error]).to eq("Email or Password not found")
      end

      it "renders new template" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "#DELETE destry" do
    before do
      log_in(user)
      delete :destroy
    end

    it "sets cookies to nil" do
      expect(cookies.signed['auth_token']).to be_nil
    end

    it "redirects to get_started_path" do
      expect(response).to redirect_to(get_started_path)
    end
  end
end
