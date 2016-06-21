require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe "GET #show" do
    before do
      @user = create(:user_home)
      api_authorization_header(@user.auth_token)
      get :show, id: @user, format: :json
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

  describe "GET #personal_messages" do
    before do
      @user = create(:user_home)
      api_authorization_header(@user.auth_token)
      @user2 = create(:user_wtc)
      @message = Message.create(poster: @user, messageable: @user2, content: "hello there")
      get :personal_messages, id: @user2.id, format: :json
    end

    it "renders the messages" do
      expect(json_response).to have_key(:messages)
    end

    it "responds with HTTP status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT/PATCH #update" do
    before do
      @user = create(:user_home)
    end

    context "when it's updated" do
      before do
        patch :update, {id: @user, user: { category: "Other"} }
      end

      it "renders the json representation for the updated user" do
        expect(json_response[:category]).to eq("Other")
      end

      it "is successful" do
        expect(response).to have_http_status(200)
      end
    end

    context "when it fails" do
      before do
        patch :update, { id: @user, user: { email: 've'} }
      end

      it "renders an erros json" do
        expect(json_response).to have_key(:errors)
      end

      it "explains why it wasn't updated" do
        expect(json_response[:errors][:email]).to include "is invalid"
      end

      it "returns 422 error code" do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "POST #add_group" do
    before do
      @user = create(:user_home)
      @user.groups.delete_all
      api_authorization_header(@user.auth_token)
      post :add_group, id: @user, format: :json
    end

    it "responds with a new group" do
      expect(json_response).to have_key(:user_limit)
    end

    it "is successful" do
      expect(response).to have_http_status(200)
    end
  end
end
