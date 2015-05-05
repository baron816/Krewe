require 'rails_helper'

describe Group do
	
	context "Two users" do	
		before do
			create(:user_home)
			create(:user_wtc)
			@group = create(:group)
		end

		it 'creates a new group' do
			expect(build(:group)).to be_valid
		end

		it	'has 2 user' do
			expect(@group.users.length).to eq(2)
		end
	end

	context "Users not in same groups" do
		before do
		  create(:user_home)
		  create(:user_wtc)
		  create(:user_121)
		  create(:user_dbc)
		  create(:user_stucco)
		  @group = create(:group)
		end

		it "group has first four users. fifth is out of range" do
			expect(@group.users.length).to eq(4)
		end
	end
end