require 'spec_helper'

RSpec.describe User, type: :model do
	it "creates a user" do
		expect(build(:user)).to be_valid
	end
end