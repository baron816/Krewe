require 'rails_helper'

describe UsersController do
  before do
    @user = create(:user_home)
    @user2 = create(:user_wtc)
    session[:user_id] = @user
  end

  describe "GET #show" do
    before do
      get :show, id: @user.id
    end

    it "renders the show template" do
    	expect(response).to render_template(:show)
    end

    it "locates the user" do
    	expect(assigns[:user]).to eql(@user)
    end
  end

  describe "GET #public_profile" do
    before do
      get :public_profile, user_id: @user2.id
      @message = PersonalMessage.create(sender: @user, receiver: @user2, content: "The message content")
    end

    it "renders public_profile template" do
    	expect(response).to render_template(:public_profile)
    end

    it "returns the personal messages" do
    	expect(assigns[:personal_messages]).to include(@message)
    end
  end

  describe "GET #edit" do
    before do
      get :edit, id: @user.id
    end

    it "renders the edit template" do
    	expect(response).to render_template(:edit)
    end

    it "finds the correct_user" do
    	expect(assigns[:user]).to eql(@user)
    end
  end
end