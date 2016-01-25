require "rails_helper"

describe TopicShow do
  let!(:user1) { create(:user_home) }
  let!(:user2) { create(:user_home) }
  let(:topic) { Topic.first }

  let(:topic_show) { TopicShow.new(topic, 1, user1)}

  describe "#messages" do
    before do
      create_list(:message, 7, poster: user2, messageable: topic)
    end

    it "returns all the messages" do
      expect(topic_show.messages.count).to eq(7)
    end

    it "returns just 5 messages after dismissal" do
      user1.dismiss_topic_notifications_from_topic(topic)
      expect(topic_show.messages.count).to eq(5)
    end
  end

  describe "#new_message" do
    it "has a new message" do
      expect(topic_show.new_message).to be_a(Message)
    end
  end

  describe "#names_data" do
    it "has a names data object" do
      expect(JSON.parse(topic_show.names_data).any? { |hash| hash["full_name"] == user2.name }).to eq(true)
    end
  end
end
