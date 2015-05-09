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
		  sleep(0.6)
		  create(:user_121)
		  sleep(0.6)
		  create(:user_dbc)
		  sleep(0.6)
		  create(:user_stucco)
		  sleep(0.6)
		  create(:user_8th_st)
		  sleep(0.6)
		  create(:user_gd)
		  @group = create(:group)
		  @group2 = create(:group)
		  @group3 = create(:group)
		end

		it "group has first four users. fifth is out of range" do
			expect(@group.users.length).to eq(4)
		end

		it "second group only has one user" do
			expect(@group2.users.length).to eq(2)
		end

		it "third group doesn't find anyone but the original user" do
			expect(@group3.users.length).to eq(1)
		end

		it "first group adds more users, but doesn't go over the limit" do
			sleep(0.6)
			create(:user_138)
			sleep(0.6)
			create(:user_122)
			sleep(0.6)
			create(:user_130)

			@group.get_more_users
			expect(@group.users.length).to eq(6)
		end
	end
end