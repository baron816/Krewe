require 'rails_helper'

RSpec.describe Api::V1::ActivitiesController, type: :controller do
  before do
    @user = create(:user_home)
    @group = @user.groups.first
    cookies[:auth_token] = @user.auth_token
  end

  describe "POST #create" do
    context "when successful" do
      before do
        @activity_attributes = attributes_for(:activity)
        @activity_attributes[:group_id] = @group.id
        @activity_attributes[:proposer_id] = @user.id
        post :create, { activity: @activity_attributes }
      end

      it "is successful" do
        expect(response).to have_http_status(201)
      end

      it "returns the created activity" do
        expect(json_response[:location]).to eq("South Street Seaport")
      end
    end

    context "when not successful" do
      before do
        @activity_attributes = attributes_for(:activity)
        @activity_attributes[:location] = nil
        post :create, { activity: @activity_attributes}
      end

      it "is not succsssful" do
        expect(response).to have_http_status(422)
      end

      it "has an errors json" do
        expect(json_response).to have_key(:errors)
      end

      it "indicates the error" do
        expect(json_response[:errors][:location]).to eq(["can't be blank"])
      end
    end
  end
end
