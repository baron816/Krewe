require "rails_helper"

describe "Message" do
  let!(:user) { create(:user_home) }
  let!(:user2) { create(:user_wtc) }

  before do
    create(:user_121)
  end

  context "topic message" do
    let(:topic) { Topic.first }
    let(:message) { create(:message, poster: user, messageable: topic) }

    it "has string content" do
      expect(message.content).to be_a(String)
    end

    it "has a user" do
    	expect(message.poster).to be_a(User)
    end

    it "has a group" do
    	expect(message.messageable).to be_a(Topic)
    end
  end

  context "personal message" do
    let!(:message2) { create(:message, poster: user, messageable: user2) }

    it "messageable is user" do
      expect(message2.messageable).to be_a(User)
    end

    it "personal_messages has one message" do
      expect(Message.personal_messages(user, user2).count).to eq(1)
    end
  end

  context 'activity message' do
    let(:activity) { create(:activity_future, group: Group.first) }
    let(:message3) { create(:message, poster: user, messageable: activity)}

    it "makes messageable an activity" do
      expect(message3.messageable).to be_an(Activity)
    end
  end
end
