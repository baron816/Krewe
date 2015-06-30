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
      
    end

    it "creates a new activity" do
    	expect { post :create, group_id: @group.id, activity: @activity_attributes }.to change(Activity, :count).by(1)
    end
  end

  describe "PUT #add_user" do
  	before do
  	  @activity = create(:activity)
  	end

    it "adds the activity to users activities" do
    	expect { put :add_user, group_id: @group, activity_id: @activity }.to change(@user.activities, :count).by(1)
    end

    it "finds the correct activity" do
    	put :add_user, group_id: @group, activity_id: @activity
    	expect(assigns[:activity]).to eq(@activity)
    end
  end
end