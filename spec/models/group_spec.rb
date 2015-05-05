require 'rails_helper'

describe Group do
	before do
		@user = create(:user_home)
		create(:user_wtc)
	end

	it 'creates a new group' do
		expect(build(:group)).to be_valid
	end

	before do
		@group = create(:group)
	end

	it	'has 1 user' do
		expect(@group.users.length).to eq(2)
	end
end