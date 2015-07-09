require 'rails_helper'

describe UsersController do
  before do
    @user = create(:user_home)
    @user2 = create(:user_wtc)
    cookies[:auth_token] = @user.auth_token
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

  describe "PATCH/PUT #update" do
    before do
      put :update, { id: @user.id, user: { category: "Young Parent" } }
    end

    it "changes user category to young parent" do
    	expect(assigns[:user].category).to eql("Young Parent")
    end
  end

  describe "POST #create" do
    before do
      @user_attributes = attributes_for(:user_121)
    end

    it "creates a user" do
    	expect { post :create, user: @user_attributes }.to change(User, :count).by(1)
    end

    it "redirects to user" do
    	post :create, user: @user_attributes
    	expect(response).to redirect_to user_path(assigns[:user])
    end
  end

  describe "GET #new" do
    before do
      get :new
    end

    it "makes a new user" do
    	expect(assigns[:user]).to be_a_new(User)
    end

    it "renders new template" do
    	expect(response).to render_template(:new)
    end
  end

  describe "POST #add_group" do
    it "adds a group" do
    	expect { post :add_group, user_id: @user.id }.to change(@user.groups, :count).by(1)
    end
  end
end