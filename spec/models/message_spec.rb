require "rails_helper"

describe "Message" do
  let!(:user) { create(:user_home) }
  let!(:user2) { create(:user_wtc) }

  before do
    create(:user_121)
  end

  context "topic message" do
    let!(:topic) { Topic.first }
    let!(:message) { Message.create(messageable: topic, poster: user, content: Faker::Lorem.sentence(5, true, 8)) }

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
    let!(:message2) { Message.create(messageable: user2, poster: user, content: Faker::Lorem.sentence(5, true, 8)) }

    it "messageable is user" do
      expect(message2.messageable).to be_a(User)
    end

    it "personal_messages has one message" do
      expect(Message.personal_messages(user, user2).count).to eq(1)
    end
  end
end
