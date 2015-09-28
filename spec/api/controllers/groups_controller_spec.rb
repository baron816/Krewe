require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :controller do
  before do
    user = create(:user_home)
    api_authorization_header(user.auth_token)
    @group = user.groups.first
  end

  describe "GET #show" do
    before do
      get :show, id: @group.id
    end

    it "is successful" do
      expect(response).to have_http_status(200)
    end

    it "returns the correct json data" do
      expect(json_response[:name]).to eq(@group.name)
    end
  end

  describe "DELETE #drop_user" do
    before do
      delete :drop_user, id: @group.id
    end

    it "is successful" do
      expect(response).to have_http_status(204)
    end
  end
end
