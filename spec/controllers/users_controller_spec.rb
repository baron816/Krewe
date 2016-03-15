require 'rails_helper'

describe UsersController do
  let!(:user) { create(:user_home)}
  let!(:user2) { create(:user_wtc) }
  let!(:group) { Group.first }

  describe "GET #show" do
    context "no user" do
      before do
        get :show, id: user
      end

      it "redirects to get_started_path" do
        expect(response).to redirect_to(get_started_path)
      end
    end

    context "sign up not complete" do
      let!(:incomplete_user) { create(:user_home, sign_up_complete: false)}

      before do
        log_in(incomplete_user)
        get :show, id: incomplete_user
      end

      it "redirects to new_user_path" do
        expect(response).to redirect_to(complete_sign_up_users_path)
      end
    end

    context "sign up complete" do
      before do
        log_in(user)
        get :show, id: user
      end

      it "renders the show template" do
      	expect(response).to render_template(:show)
      end

      it "locates the user" do
      	expect(assigns[:user_show]).to eql(user)
      end
    end
  end

  describe "GET #personal_messages" do
    let!(:message) {  Message.create(poster: user, messageable: user2, content: "The message content") }
    before do
      log_in(user)
      get :personal_messages, id: user2
    end

    it "renders personal_messages template" do
    	expect(response).to render_template(:personal_messages)
    end

    it "returns the personal messages" do
    	expect(assigns[:user].messages).to include(message)
    end
  end

  describe "GET #edit" do
    before do
      log_in(user)
      get :edit, id: user
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
      log_in(user)
      put :update, { id: user, user: { category: "Young Parent" } }
    end

    it "changes user category to young parent" do
    	expect(assigns[:user].category).to eql("Young Parent")
    end
  end


  describe "GET #complete_sign_up" do
    let(:user) { create(:user_home) }
    before do
      log_in(user)
      get :complete_sign_up
    end

    it "makes a new user" do
    	expect(assigns[:user]).to eq(user)
    end

    it "renders new template" do
    	expect(response).to render_template(:complete_sign_up)
    end
  end

  describe "#DELETE #destroy" do
    before do
      log_in(user)
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
