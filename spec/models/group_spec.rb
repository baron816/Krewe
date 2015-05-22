require 'rails_helper'

describe Group do
	before do
		create(:user_home)
		create(:user_wtc)
		@group1 = Group.first
	end
	
	context "two users" do	

		it 'creates a new group' do
			expect(build(:group)).to be_valid
		end

		it	'has 2 user' do
			@group1 = Group.first
			expect(@group1.users.length).to eq(2)
		end
	end

	context "more users" do
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

		context "when group not full" do
			describe "#drop_user" do
			  it "correctly removes a user" do
			  	@group1.drop_user(User.first)
			  	expect(@group1.users.count).to eq(3) 
			  end

			  context "description" do
			  	before do  
			  	sleep(0.6)
	  	        create(:user_138)
		        sleep(0.6)
		        create(:user_122)
		        sleep(0.6)
		        create(:user_130)
			  	end
			  	
				  it "still adds users to first group" do
			        expect(@group1.users.count).to eql(6)
				  end

				  it "resets can_join to true" do
				  	@group1.drop_user(User.first)
				  	expect(@group1.can_join).to be true
				  end
			  end

			end
		end

	end
	
end