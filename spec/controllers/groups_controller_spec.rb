require 'rails_helper'

describe GroupsController do
  before do
    @user = create(:user_home)
    @group = @user.groups.first
    cookies[:auth_token] = @user.auth_token
  end

  describe "GET #show" do
  	before do
  	  get :show, id: @group
  	end

    it "renders show template" do
    	expect(response).to render_template(:show)
    end

    it "finds the correct group" do
    	expect(assigns[:group_show].group).to eq(@group)
    end

    it "has a new message" do
    	expect(assigns[:group_show].new_message).to be_a_new(Message)
    end
  end

  describe "DELETE #drop_user" do
  	it "finds the correct group" do
  		delete :drop_user, id: @group
  		expect(assigns[:group]).to eq(@group)
  	end

    it "drops the user's group and creates a new one" do
    	expect { delete :drop_user, id: @group }.to change(@user.groups, :count).by(0)
    end

    it "only drops the user's group if it's not a first degree group" do
      @group.update_column(:degree, 3)
      expect { delete :drop_user, id: @group }.to change(@user.groups, :count).by(-1)
    end
  end
end
