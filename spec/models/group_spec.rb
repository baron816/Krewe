require 'rails_helper'

describe Group do
	before do
		create(:user_home)
		create(:user_wtc)
		@group1 = Group.first
	end
	
	context "Two users" do	

		it 'creates a new group' do
			expect(build(:group)).to be_valid
		end

		it	'has 2 user' do
			@group1 = Group.first
			expect(@group1.users.length).to eq(2)
		end
	end

	context "Users divided into groups correctly" do
		before do
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
		  @group2 = Group.second
		  @group3 = Group.third
		end

		it "group has first four users. fifth is out of range" do
			expect(@group1.users.length).to eq(4)
		end

		it "second group only has one user" do
			expect(@group2.users.length).to eq(2)
		end

		it "third group doesn't find anyone but the original user" do
			expect(@group3.users.length).to eq(1)
		end

		describe "#drop_user" do
		  it "correctly removes a user" do
		  	@group1.drop_user(User.first)
		  	expect(@group1.users.count).to eq(3) 
		  end
		end
	end
end