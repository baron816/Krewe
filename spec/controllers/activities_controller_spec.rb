require "rails_helper"

describe ActivitiesController do
  before do
    @user = create(:user_home)
    @group = @user.groups.first
    cookies[:auth_token] = @user.auth_token
  end

  describe "POST #create" do
    before do
      @activity_attributes = attributes_for(:activity_future)
      @activity_attributes[:group_id] = @group.id
      @activity_attributes[:proposer_id] = @user.id
    end

    it "creates a new activity" do
    	expect { post :create, group_id: @group, activity: @activity_attributes }.to change(Activity, :count).by(1)
    end
  end

	before do
	  @activity = build(:activity_future)
    @activity.group = @group
    @activity.save
	end

  describe "PUT #add_user" do

    it "adds the activity to users activities" do
    	expect { put :add_user, group_id: @group, id: @activity }.to change(@user.activities, :count).by(1)
    end

    it "finds the correct activity" do
    	put :add_user, id: @activity, group_id: @group
    	expect(assigns[:activity]).to eq(@activity)
    end
  end

  describe "GET #show" do
    before do
      get :show, id: @activity, group_id: @group
    end

    it "renders the show template" do
    	expect(response).to render_template(:show)
    end

    it "gets the correct activity" do
    	expect(assigns[:activity]).to eql(@activity)
    end
  end

  describe "DELETE #remove_user" do
    before do
      @activity.users << @user
    end

    it "removes the user from the activity" do
      expect { delete :remove_user, id: @activity, group_id: @group }.to change(@user.activities, :count).by(-1)
    end
  end

  describe "GET #edit" do
    before do
      get :edit, id: @activity, group_id: @group
    end

    it "renders the edit view" do
      expect(response).to render_template(:edit)
    end

    it "finds the correct activity" do
      expect(assigns[:activity]).to eql(@activity)
    end
  end

  describe "PUT #update" do
    before do
      put :update, {group_id: @group, id: @activity, activity: {plan: "Get some sodas"}}
    end

    it "changes the plan to get some sodas" do
      expect(assigns[:activity].plan).to eql("Get some sodas")
    end
  end
end
