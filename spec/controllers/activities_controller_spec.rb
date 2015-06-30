require "rails_helper"

describe ActivitiesController do
  before do
    @user = create(:user_home)
    @group = @user.groups.first
    session[:user_id] = @user
  end

  describe "POST #create" do
    before do
      @activity_attributes = {plan: "Dinner", proposer_id: @user, appointment: "2015-07-01 00:55:00" }
      
    end

    it "creates a new activity" do
    	expect { post :create, group_id: @group.id, activity: @activity_attributes }.to change(Activity, :count).by(1)
    end
  end
end