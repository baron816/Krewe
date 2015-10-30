require "rails_helper"

describe "Message" do
  let!(:user) { create(:user_home) }
  let!(:message) { Message.create(messageable: user.groups.first.topics.first, poster: user, content: Faker::Lorem.sentence(5, true, 8)) }

  before do
    create(:user_wtc)
    create(:user_121)
  end

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
