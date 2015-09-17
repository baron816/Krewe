require "rails_helper"

describe "Message" do
  before do
    @user = create(:user_home)
    create(:user_wtc)
    create(:user_121)
    @message = Message.create(messageable: @user.groups.first, poster: @user, content: Faker::Lorem.sentence(5, true, 8))
  end

  it "has string content" do
    expect(@message.content).to be_a(String)
  end

  it "has a user" do
  	expect(@message.poster).to be_a(User)
  end

  it "has a group" do
  	expect(@message.messageable).to be_a(Group)
  end

  it "has a group with a latitude" do
    expect(@message.messageable.latitude).to eql(40.7094706)
  end
end
