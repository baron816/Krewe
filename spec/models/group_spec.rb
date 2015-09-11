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

		context "when group not full" do
			describe "#drop_user" do
			  it "correctly removes a user" do
			  	group1.drop_user(User.first)
			  	expect(group1.users.count).to eq(3)
			  end

			  context "description" do
				  before do
		  	    create(:user_138)
		        create(:user_122)
		        create(:user_130)
					end

				  it "still adds users to first group" do
			        expect(group1.users.count).to eql(6)
				  end

				  it "resets can_join to true" do
				  	group1.drop_user(User.first)
				  	expect(group1.can_join).to be true
				  end
			  end
			end
		end
	end

	describe "#ripe_for_expansion" do
		let(:group4) { create(:old_group) }

		it "does not indicate group is ripe for expansion" do
		  expect(group4.ripe_for_expansion?).to eq(false)
		end

		it "is right for expansion with activities" do
			4.times do
				group4.activities << create(:activity_past)
			end

			expect(group4.ripe_for_expansion?).to eq(true)
		end
	end

	describe "#expand_group" do
		before do
			create(:user_121)
			create(:user_dbc)
			create(:user_138)
			create(:user_122)
		end

		it "starts with only one group" do
		  expect(Group.count).to eq(1)
		end

		it "returns nil when expanding" do
		  expect(ExpandGroup.new(group1).expand_group).to eq(nil)
		end

		context "group1 expands" do
			before do
				ExpandGroup.new(group1).expand_group
			end

			it "does not expand_group but sets ready_to_expand to true" do
				expect(group1.ready_to_expand).to eq(true)
			end

			it "still only has one group" do
			  expect(Group.count).to eq(1)
			end
		end

		context "more users create new group" do
			before do
				ExpandGroup.new(group1).expand_group
				create(:user_130)
				create(:user_134)
			end

			let(:group2) { Group.second }

			it "new users create more groups" do
				expect(Group.count).to eq(2)
			end

			it "expanding group returns a new group" do
			  expect(ExpandGroup.new(group2).expand_group).to be_a(Group)
			end

			context "after new group is created" do
				before do
					@group3 = ExpandGroup.new(group2).expand_group
				end

				it "expanding again creates a new group" do
					expect(Group.count).to eq(3)
				end

				it "has all the users" do
					expect(@group3.users).to eq(User.all)
				end
			end
		end

		context "third degree group" do
			before do
				18.times do
					create(:user_dbc)
				end

				Group.find_each do |group|
					ExpandGroup.new(group).expand_group
				end
			end

			let(:group5) { Group.fifth }
			let(:group6) { Group.last }

			it "expanding every group creates two more groups" do
				expect(Group.count).to eq(6)
			end

			it "last two groups are second degree groups" do
			  expect(group5.degree).to eq(2)
				expect(group6.degree).to eq(2)
			end

			it "last two groups have 12 users each" do
				expect(group5.users.count).to eq(12)
				expect(group6.users.count).to eq(12)
			end

			context "expanding to third degree" do
				before do
					ExpandGroup.new(group5).expand_group
				end

				let(:group7) { ExpandGroup.new(group6).expand_group }

				it "expanding last two groups creates a new group" do
					expect(group7).to be_a(Group)
				end

				it "new group has 24 users " do
					expect(group7.users.count).to eq(24)
				end

				it "new group has degree of 3" do
				  expect(group7.degree).to eq(3)
				end

				it "does not create a new group when expanding group 7" do
				  expect(ExpandGroup.new(group7).expand_group).to be(nil)
				end
			end
		end
	end
end
