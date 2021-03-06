require 'rails_helper'

RSpec.describe Api::V1::ActivitiesController, type: :controller do
  before do
    @user = create(:user_home)
    api_authorization_header(@user.auth_token)
    @group = @user.groups.first
  end

  describe "POST #create" do
    context "when successful" do
      before do
        @activity_attributes = attributes_for(:activity_future)
        @activity_attributes[:group_id] = @group.id
        @activity_attributes[:proposer_id] = @user.id
        post :create, { activity: @activity_attributes, group_id: @group }
      end

      it "is successful" do
        expect(response).to have_http_status(201)
      end

      it "returns the created activity" do
        expect(json_response[:location]).to eq(@activity_attributes[:location])
      end
    end

    context "when not successful" do
      before do
        @activity_attributes = attributes_for(:activity_future)
        @activity_attributes[:location] = nil
        post :create, { activity: @activity_attributes, group_id: @group}
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

  before do
    @activity = build(:activity_future)
    @activity.group = @group
    @activity.save
  end

  describe "GET #show" do
    before do
      get :show, id: @activity, group_id: @group
    end

    it "is successful" do
      expect(response).to have_http_status(200)
    end

    it "returns the json representation of the activity" do
      expect(json_response[:location]).to eq(@activity.location)
    end
  end

  describe "PUT/PATCH #update" do
    context "when succsssfully updated" do
      before do
        patch :update, { id: @activity, group_id: @group, activity: { location: "Empire State Building"} }
      end

      it "is successful" do
        expect(response).to have_http_status(200)
      end

      it "renders the json representation with the updated activity" do
        expect(json_response[:location]).to eq("Empire State Building")
      end
    end

    context "when update is unsuccessful" do
      before do
        patch :update, { id: @activity, group_id: @group, activity: { location: nil } }
      end

      it "is not successful" do
        expect(response).to have_http_status(422)
      end

      it "has an errors json" do
        expect(json_response).to have_key(:errors)
      end

      it "says what the problem is" do
        expect(json_response[:errors][:location]).to eq(["can't be blank"])
      end
    end
  end

  describe "POST #add_user" do
    before do
      post :add_user, id: @activity, group_id: @group
    end

    it "is successful" do
      expect(response).to have_http_status(201)
    end

    it "returns the activity" do
      expect(json_response[:location]).to eq(@activity.location)
    end
  end

  describe "DELETE #remove_user" do
    before do
      delete :remove_user, { id: @activity, group_id: @group }
    end

    it "is successful" do
      expect(response).to have_http_status(204)
    end
  end
end
