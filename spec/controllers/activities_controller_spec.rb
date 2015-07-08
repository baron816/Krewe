require "rails_helper"

describe ActivitiesController do
  before do
    @user = create(:user_home)
    @group = @user.groups.first
    session[:user_id] = @user
  end

  describe "POST #create" do
    before do
      @activity_attributes = attributes_for(:activity)
      @activity_attributes[:group_id] = @group.id
      @activity_attributes[:proposer_id] = @user.id
    end

    it "creates a new activity" do
    	expect { post :create, group_id: @group.id, activity: @activity_attributes }.to change(Activity, :count).by(1)
    end
  end

	before do
	  @activity = build(:activity)
    @activity.group = @group
    @activity.save
	end

  describe "PUT #add_user" do

    it "adds the activity to users activities" do
    	expect { put :add_user, group_id: @activity.group, activity_id: @activity }.to change(@user.activities, :count).by(1)
    end

    it "finds the correct activity" do
    	put :add_user, group_id: @activity.group, activity_id: @activity
    	expect(assigns[:activity]).to eq(@activity)
    end
  end

  describe "GET #show" do
    before do
      get :show, group_id: @group, id: @activity
    end

    it "renders the show template" do
    	expect(response).to render_template(:show)
    end

    it "gets the correct activity" do
    	expect(assigns[:activity]).to eql(@activity)
    end
  end
end