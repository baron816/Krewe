require "rails_helper"

describe UserPersonalMessageShow do
  let(:user1){ create(:user_home) }
  let(:user2){ create(:user_home) }
  let(:personal_messages) { UserPersonalMessageShow.new(user1, user2, 1) }

  describe "#personal_messages" do
    before do
      create_list(:message, 4, poster: user1, messageable: user2)
      create_list(:message, 4, poster: user1, messageable: user2)
    end

    it "returns all the messages" do
      expect(personal_messages.personal_messages.count).to eq(8)
    end

    it "only returns 5 messages when no unviewed notifications" do
      user2.dismiss_personal_notifications_from_user(user1)
      expect(personal_messages.personal_messages.count).to eq(5)
    end
  end

  describe "#new_message" do
    it "initializes a new message" do
      expect(personal_messages.new_message).to be_a(Message)
    end
  end
end
