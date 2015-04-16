require 'rails_helper'

describe User do
  it "factory creates a user" do
  	expect(build(:user)).to be_valid
  end
end