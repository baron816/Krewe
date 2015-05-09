require "rails_helper"

describe "Message" do
  it "builds a message" do
  	expect(build(:message)).to be_valid
  end
end