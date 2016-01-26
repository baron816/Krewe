require "rails_helper"

describe GroupShow do
  let!(:user1) { create(:user_home) }
  let!(:user2) { create(:user_home) }
  let(:group) { Group.first }

  let(:group_show) { GroupShow.new(group, user1, 1) }

  describe "#user_expand_group_votes" do
    let!(:expand_vote) { user1.expand_group_votes.create(group: group) }

    it "has a vote from user1" do
      expect(group_show.user_expand_group_votes(user1)).to eq(expand_vote)
    end

    it "doesnt have any votes from user2" do
      expect(group_show.user_expand_group_votes(user2)).to be_nil
    end
  end

  describe "#not_almost_expandable?" do
    it "is not about to expand without any votes" do
      expect(group_show.not_almost_expandable?).to eq(true)
    end

    it "it is about to expand with one less vote than users count" do
      user2.expand_group_votes.create(group: group)
      expect(group_show.not_almost_expandable?).to eq(false)
    end
  end

  describe "#activities" do
    let!(:future_activity) { create(:activity_future, group: group) }
    let!(:past_activity) { create(:activity_past, group: group) }

    it "returns a collection with the future activity" do
      expect(group_show.activities).to include(future_activity)
    end

    it "does not include the past activity" do
      expect(group_show.activities).not_to include(past_activity)
    end
  end

  describe "#topics" do
    before do
      create_list(:topic, 7, group: group)
    end

    it "returns the first 5 topics" do
      expect(group_show.topics.count).to eq(5)
    end

    it "returns the last 3 topics on the second page" do
      expect(GroupShow.new(group, user1, 2).topics.count).to eq(3)
    end
  end

  describe "#topic" do
    it "returns a topic show" do
      expect(group_show.topic).to be_a(TopicShow)
    end

    it "is the default topic" do
      expect(group_show.topic.name).to eq("General")
    end
  end

  describe "#dismiss_first_topic_notifications" do
    before do
      create_list(:message, 4, poster: user2, messageable: Topic.first)
    end

    it "has 4 topic notifications for user1" do
      expect(user1.unviewed_message_notifications_from_topic_count(Topic.first)).to eq(4)
    end

    it "dismisses those notifications" do
      group_show.dismiss_first_topic_notifications
      expect(user1.unviewed_message_notifications_from_topic_count(Topic.first)).to be_nil
    end
  end

  describe "#new_topic" do
    it "is a new topic" do
      expect(group_show.new_topic).to be_a(Topic)
    end
  end
end
