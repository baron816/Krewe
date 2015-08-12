require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe "GET #show" do
    before do
      @user = create(:user_home)
      cookies[:auth_token] = @user.auth_token
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a user" do
      expect(json_response[:email]).to eq(@user.email)
    end
  end
end
