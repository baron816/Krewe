require 'rails_helper'

describe SessionsController do


  describe "#POST create" do
    context "user doesn't exist yet" do
      before do
        omniauth_headers({provider: "facebook", uid: "12355", info: {email: "myEmail@mail.com", name: "Dude McAwesome"}})
      end

      it "creates a new user" do
        expect { post :create, provider: :facebook }.to change(User, :count).by(1)
      end

      it "redirects to new_user_path" do
        post :create, provider: :facebook
        expect(response).to redirect_to(new_user_path)
      end

      it "logs in the new user" do
        post :create, provider: :facebook
        expect(cookies.signed[:auth_token]).to eq(User.last.auth_token)
      end
    end

    context "user exists" do
      let!(:user) { create(:baron) }

      before do
        omniauth_headers(omniauth_mock_attributes(user))
      end

      it "does not create a new user" do
        expect { post :create, provider: :facebook }.to change(User, :count).by(0)
      end

      it "redirects to root" do
        post :create, provider: :facebook
        expect(response).to redirect_to(root_path)
      end

      it "signs in the user" do
        post :create, provider: :facebook
        expect(cookies.signed[:auth_token]).to eq(user.auth_token)
      end
    end
  end

  describe "#DELETE destroy" do
    let!(:user) { create(:baron) }
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
