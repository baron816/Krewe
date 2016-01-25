require 'rails_helper'

describe ActivityShow do
  let!(:user1) { create(:user_home) }
  let!(:user2) { create(:user_home) }
  let(:activity) { create(:activity_future, proposer: user1, group: Group.first) }

  let(:activity_show) { ActivityShow.new({user: user1, activity: activity, page: 1})}

  before do
    activity.users << [user2]
    create_list(:message, 7, poster: user2, messageable: activity)
  end

  describe "#note_count" do
    it "has seven notifications" do
      expect(activity_show.note_count).to eq(7)
    end
  end

  describe "#messages" do
    it "has 7 messages" do
      expect(activity_show.messages.count).to eq(7)
    end

    it "shows first five messages when all notifications seen" do
      user1.dismiss_activity_notification(activity)
      expect(activity_show.messages.count).to eq(5)
    end
  end

  describe "#new_message" do
    it "has a new message" do
      expect(activity_show.new_message).to be_a(Message)
    end
  end
end
