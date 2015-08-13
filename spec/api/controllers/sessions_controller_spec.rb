require 'rails_helper'

describe Api::V1::SessionsController, type: :controller do
  describe "POST #create" do
    before do
      @user = create(:user_home)
    end

    context "when the credentials are correct" do
      before do
        credentials = { email: @user.email, password: '123456' }
        post :create, { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(json_response[:auth_token]).to eq(@user.auth_token)
      end

      it "is successful" do
        p json_response
        expect(response).to have_http_status(200)
      end
    end
  end
end
