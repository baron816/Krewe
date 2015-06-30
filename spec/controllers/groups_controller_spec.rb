require 'rails_helper'

describe GroupsController do
  describe "GET #show" do
  	before do
  	  @user = create(:user_home)
  	  @group = @user.groups.first
  	  session[:user_id] = @user
  	  get :show, id: @group
  	end

    it "renders show template" do
    	expect(response).to render_template(:show)
    end

    it "finds the correct group" do
    	expect(assigns[:group]).to eq(@group)
    end

    it "has a new message" do
    	expect(assigns[:message]).to be_a_new(Message)
    end

    it "has a new activity" do
    	expect(assigns[:activity]).to be_a_new(Activity)
    end
  end
end