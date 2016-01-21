require 'rails_helper'

describe PasswordResetsController do
  let(:user) { create(:user_home) }
  before do
    UserPasswordReset.new(user).send_password_reset
  end

  describe "#GET new" do
    before do
      get :new
    end

    it "renders the template" do
      expect(response).to render_template(:new)
    end
  end

  describe "#POST create" do
    before do
      post :create, password_reset: { email: user.email }
    end

    it "finds the correct user" do
      expect(assigns[:user]).to eq(user)
    end

    it "redirects to root" do
      expect(response).to redirect_to(root_path)
    end

    it "sets a notice" do
      expect(flash.notice).to eq("An email was just sent to #{user.email} to reset your password. It will expire in one hour.")
    end
  end

  describe "#GET edit" do
    context "not a valid token" do
      before do
        get :edit, id: 'badtoken'
      end

      it "redirects to " do
        expect(response).to redirect_to(get_started_path)
      end
    end

    context "valid token" do
      before do
        get :edit, id: user.password_reset_token
      end

      it "renders edit template" do
        expect(response).to render_template(:edit)
      end

      it "finds the right user" do
        expect(assigns[:user]).to eq(user)
      end
    end
  end

  describe "#PUT/PATCH update" do
    context "empty password field" do
      before do
        put :update, id: user.password_reset_token, user: { password: "12ab34CD", password_confirmation: ""}
      end

      it "renders edit template" do
        expect(response).to render_template(:edit)
      end

      it "flashes error" do
        expect(flash.now[:danger]).to eq("Password can't be empty")
      end
    end

    context "good password" do
      before do
        put :update, id: user.password_reset_token, user: { password: "12ab34CD", password_confirmation: "12ab34CD" }
      end

      it "logs user in" do
        expect(cookies.signed["auth_token"]).to eq(user.auth_token)
      end

      it "redirects to root path" do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
