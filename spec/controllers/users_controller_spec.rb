require 'rails_helper'

describe UsersController do
  let!(:user) { create(:user_home)}
  let!(:user2) { create(:user_wtc) }
  let!(:group) { Group.first }

  describe "GET #new" do
    before do
      get :new
    end

    it "renders the new template" do
      expect(response).to render_template(:new)
    end

    it "creates a new user" do
      expect(assigns[:user]).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "valid password" do
      let!(:user_attributes) { attributes_for(:email_provider, password: "mdsgvzj48*()") }

      it "creates a new user" do
        expect { post :create, user: user_attributes }.to change(User, :count).by(1)
      end

      it "redirects to verify_email users path" do
        post :create, user: user_attributes
        expect(response).to redirect_to(verify_email_users_path)
      end
    end

    context "invalid password" do
      let!(:invalid_password_user_attributes) { attributes_for(:email_provider, password: "password")}

      it "does not save the user" do
        expect { post :create, user: invalid_password_user_attributes }.to change(User, :count).by(0)
      end

      it "renders new template" do
        post :create, user: invalid_password_user_attributes
        expect(response).to render_template(:new)
      end
    end
  end

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
    context "needs verification" do
      let(:user) { create(:user_home) }
      before do
        log_in(user)
        get :complete_sign_up
      end

      it "makes a new user" do
      	expect(assigns[:user]).to eq(user)
      end

      it "renders new template" do
      	expect(response).to redirect_to(verify_email_users_path)
      end
    end

    context "does not need verification" do
      let(:user) { create(:user_home, email_verified: true) }
      before do
        log_in(user)
        get :complete_sign_up
      end

      it "renders new template" do
        expect(response).to render_template(:complete_sign_up)
      end
    end
  end

  describe "#GET verify_email" do
    it "redirects to root if sign up is complete" do
      log_in(user)
      get :verify_email
      expect(response).to redirect_to root_path
    end

    it "renders template if sign up is not complete" do
      user = create(:user_home, sign_up_complete: false)
      log_in(user)
      get :verify_email
      expect(response).to render_template(:verify_email)
    end
  end

  describe "#GET email_confirmed" do
    it "the user's email is not verified" do
      expect(user.email_verified?).to eq(false)
    end

    context "user has correct code" do
      before do
        get :email_confirmed, id: user, code: user.password_reset_token
      end

      it "logs in the user" do
        expect(cookies.signed[:auth_token]).to eq(user.auth_token)
      end

      it "sets email_verified to true" do
        user.reload
        expect(user.email_verified?).to eq(true)
      end

      it "redirects to complete_sign_up_users_path" do
        expect(response).to redirect_to(complete_sign_up_users_path)
      end
    end

    context "user has wrong code" do
      before do
        get :email_confirmed, id: user, code: '12345'
      end

      it "redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#PATCH update_email" do

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

    it "redirects to a new survey" do
      expect(response).to redirect_to new_survey_path(email: user.email)
    end
  end
end
