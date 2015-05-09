require "rails_helper"

describe "Message" do
  it "builds a message" do
  	expect(build(:message)).to be_valid
  end

  before do
    @message = create(:message)
  end

  it "has string content" do
  	expect(@message.content).to be_a(String)
  end

  it "has a user" do
  	expect(@message.user).to be_a(User)
  end

  it "has a group" do
  	expect(@message.group).to be_a(Group)
  end
end