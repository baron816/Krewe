require 'rails_helper'

describe MessagesController do
  let(:user) { create(:user_home)}

  before do
    log_in(user)
  end

  describe "#POST create" do
    context "topic message" do
      let(:topic) { Topic.first }

      it "creates a message" do
        expect { post :create, topic_id: topic, message: { content: "this is my message"} }.to change(Message, :count).by(1)
      end
    end

    context "user message" do
      let(:user2) { create(:user_home) }

      it "creates a message" do
        expect { post :create, user_id: user2, message: { content: "a personal message"} }.to change(Message, :count).by(1)
      end
    end

    context "activity message" do
      let(:activity) { create(:activity_future) }
      before do
        Group.first.activities << activity
      end

      it "creates a message" do
        expect { post :create, activity_id: activity, message: { content: "an activity message"} }.to change(Message, :count).by(1)
      end
    end
  end

  describe "#GET index" do
    let(:activity) { create(:activity_future)}
    before do
      get :index, activity_id: activity
    end

    it "makes an instance of activity show" do
      expect(assigns[:activity]).to be_a(ActivityShow)
    end

    it "renders the message index" do
      expect(response).to render_template(:index)
    end
  end
end
