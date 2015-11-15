require 'rails_helper'

describe UsersController do
  let!(:user) { create(:user_home)}
  let!(:user2) { create(:user_wtc) }
  let!(:group) { Group.first }
  before do
    cookies[:auth_token] = user.auth_token
  end

  describe "GET #show" do
    before do
      get :show, id: user.id
    end

    it "renders the show template" do
    	expect(response).to render_template(:show)
    end

    it "locates the user" do
    	expect(assigns[:user_show]).to eql(user)
    end
  end

  describe "GET #public_profile" do
    let!(:message) {  Message.create(poster: user, messageable: user2, content: "The message content") }
    before do
      get :public_profile, id: user2.id
    end

    it "renders public_profile template" do
    	expect(response).to render_template(:public_profile)
    end

    it "returns the personal messages" do
    	expect(assigns[:user].personal_messages).to include(message)
    end
  end

  describe "GET #edit" do
    before do
      get :edit, id: user.id
    end

    it "renders the edit template" do
    	expect(response).to render_template(:edit)
    end

    it "finds the correct_user" do
    	expect(assigns[:user]).to eql(user)
    end
  end

  describe "PATCH/PUT #update" do
    before do
      put :update, { id: user.id, user: { category: "Young Parent" } }
    end

    it "changes user category to young parent" do
    	expect(assigns[:user].category).to eql("Young Parent")
    end
  end

  describe "POST #create" do
    let!(:user_attributes) { attributes_for(:user_121) }

    it "creates a user" do
    	expect { post :create, user: user_attributes }.to change(User, :count).by(1)
    end

    it "redirects to user" do
    	post :create, user: user_attributes
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

  describe "#DELETE #destroy" do
    before do
      user.expand_group_votes.create(group_id: group.id)
      user.votes_to_drop.create(group_id: group.id, user_id: user2.id)
      delete :destroy, { id: user }
    end

    it "deletes the user" do
      expect(User.count).to eq(1)
    end

    it "deletes expand group vote" do
      expect(ExpandGroupVote.count).to eq(0)
    end

    it "deletes their votes to drop user" do
      expect(DropUserVote.count).to eq(0)
    end

    it "rediects to a new survey" do
      expect(response).to redirect_to new_survey_path(email: user.email)
    end
  end
end
