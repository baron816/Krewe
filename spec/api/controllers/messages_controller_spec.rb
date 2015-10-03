require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do
  before do
    @user = create(:user_home)
    @user2 = create(:user_dbc)
    @group = @user.groups.first
    api_authorization_header(@user.auth_token)
  end

  describe "POST #create" do
    describe "User message" do
      context "is successful" do
        before do
          @message = {poster_id: @user.id, messageable_id: @user2.id, messageable_type: "User", content: "hello there"}
          post :create, { message: @message }
        end

        it "is successful" do
          expect(response).to have_http_status(201)
        end

        it "returns the created post" do
          expect(json_response[:content]).to eq('hello there')
        end
      end

      context "it fails" do
        before do
          @bad_message = {poster_id: @user.id, messageable_id: @user2.id, content: "hello there"}
          post :create, { message: @bad_message}
        end

        it "is not successful" do
          expect(response).to have_http_status(422)
        end

        it "return errors json" do
          expect(json_response).to have_key(:errors)
        end

        it "explains the error" do
          expect(json_response[:errors][:messageable_type]).to eq(["can't be blank"])
        end
      end
    end
  end
end
