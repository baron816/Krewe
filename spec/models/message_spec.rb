require "rails_helper"

describe "Message" do
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

  it "has a group with a latitude" do
    expect(@message.group.latitude).to eql(40.7094706)
  end

  
end