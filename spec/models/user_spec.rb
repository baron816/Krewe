require 'rails_helper'

describe User do
  it "factory creates a user" do
  	expect(create(:user_with_group)).to be_valid
  end

  before do
  	@user = create(:user_with_group)
  end
  it "factory has 4 groups" do
  	expect(@user.groups.length).to eq(4)
  end
end