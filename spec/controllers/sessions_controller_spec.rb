require 'rails_helper'

describe SessionsController do
  let!(:user) { create(:baron) }

  describe "#POST create" do
    context "user enters correct credentials" do
      before do
        omniauth_headers(user)
        post :create
      end

      it "redirects to the root" do
        expect(response).to redirect_to(new_user_path)
      end
    end
  end

  describe "#DELETE destroy" do
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
