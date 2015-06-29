require 'rails_helper'

describe UsersController do
  describe "GET #show" do
    before do
      @user = create(:user_home)
      session[:user_id] = @user
      get :show, id: @user.id
    end

    it "renders the show template" do
    	expect(response).to render_template(:show)
    end

    it "locates the user" do
    	expect(assigns[:user]).to eql(@user)
    end
  end
end