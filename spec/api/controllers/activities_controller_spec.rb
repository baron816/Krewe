require 'rails_helper'

RSpec.describe Api::V1::ActivitiesController, type: :controller do
  before do
    @user = create(:user_home)
    @group = @user.groups.first
    cookies[:auth_token] = @user.auth_token
  end

  describe "POST #create" do
    before do
      @activity_attributes = attributes_for(:activity)
      @activity_attributes[:group_id] = @group.id
      @activity_attributes[:proposer_id] = @user.id
      post :create, { activity: @activity_attributes }
    end

    it "is successful" do
      expect(response).to have_http_status(201)
    end
  end
end
