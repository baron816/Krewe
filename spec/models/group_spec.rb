require 'rails_helper'

describe Group do
	before do
		create(:user_home)
		create(:user_wtc)
	end

	let(:group1) { Group.first }

	it	'has 2 user' do
		expect(group1.users.count).to eq(2)
	end

	context "more users" do
		before do
		  create(:user_121)
		  create(:user_dbc)
		  create(:user_stucco)
		  create(:user_8th_st)
		  create(:user_gd)
		end
		  let(:group2) { Group.second }
		  let(:group3) { Group.third }

		it "group has first four users. fifth is out of range" do
			expect(group1.users.length).to eq(4)
		end

		it "second group only has one user" do
			expect(group2.users.length).to eq(2)
		end

		it "third group doesn't find anyone but the original user" do
			expect(group3.users.length).to eq(1)
		end
	end


end
