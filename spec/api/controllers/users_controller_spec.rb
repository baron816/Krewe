require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe "GET #show" do
    before do
      @user = create(:user_home)
      cookies[:auth_token] = @user.auth_token
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a user" do
      expect(json_response[:email]).to eq(@user.email)
    end

    it "responds with HTTP status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "when it's successfully created" do
      before do
        @user_attributes = attributes_for(:user_home)
        post :create, { user: @user_attributes }, format: :json
      end

      it "renders the json resprentation for the user record" do
        expect(json_response[:email]).to eq(@user_attributes[:email])
      end

      it "responds with HTTP status 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when it's not created" do
      before do
        @invalid_user_attributes = attributes_for(:user_home)
        @invalid_user_attributes[:password] = 'zxcvbnnn'
        post :create, { user: @invalid_user_attributes }, format: :json
      end

      it "renders and errors json" do
        expect(json_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        expect(json_response[:errors][:password_confirmation]).to include "doesn't match Password"
      end
    end
  end
end
