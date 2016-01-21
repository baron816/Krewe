require 'rails_helper'

describe TopicsController do
  let(:user) { create(:user_home) }
  let(:group) { Group.first }
  let(:topic) { group.topics.first }
  before do
    log_in(user)
  end

  describe "#GET show" do
    before do
      get :show, id: topic
    end

    it "renders the topic template" do
      expect(response).to render_template(:show)
    end

    it "sets a TopicShow instance" do
      expect(assigns[:topic]).to be_a(TopicShow)
    end
  end

  describe "#POST create" do
    it "creates a new topic" do
      expect{ post :create, group_id: group, topic: { name: "New Thread"} }.to change(Topic, :count).by(1)
    end

    it "sets a TopicShow instance" do
      post :create, group_id: group, topic: { name: "A new Thread"}
      expect(assigns[:topic]).to be_a(TopicShow)
    end
  end
end
