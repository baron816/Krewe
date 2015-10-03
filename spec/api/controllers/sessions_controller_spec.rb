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
        expect(response).to have_http_status(200)
      end
    end

    context "when credentials are wrong" do
      before do
        credentials = { email: @user.email, password: 'sdafdsa' }
        post :create, { session: credentials }
      end

      it "is not successful" do
        expect(response).to have_http_status(422)
      end

      it "has an errors json" do
        expect(json_response).to have_key(:errors)
      end

      it "says what the problem is" do
        expect(json_response[:errors]).to eq("Invalid email or password")
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      @user = create(:user_home)
      api_authorization_header @user.auth_token
      delete :destroy, id: @user.auth_token
    end

    it "is successful" do
      expect(response).to have_http_status(204)
    end
  end
end
