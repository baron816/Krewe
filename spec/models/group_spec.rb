require "rails_helper"

describe Group do
	it 'creates a new group' do
		expect(build(:group_with_user)).to be_valid
	end

	before do
		@group = create(:group_with_user)
	end

	it	'has 3 users' do
		expect(@group.users.length).to eq(3)
	end
end