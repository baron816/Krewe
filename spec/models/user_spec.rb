require 'rails_helper'

describe User do
  it "factory creates a user" do
  	expect(create(:user_home)).to be_valid
  end

  let!(:user) { create(:user_home) }

	it "user home has address" do
		expect(user.address).to eq('135 William Street, New York, NY')
	end

	it "user home has longitude coordinate" do
		expect(user.longitude).to eq(-74.00671419999999)
	end

	it "user home has latitude coordinate" do
		expect(user.latitude).to eq(40.7094706)
	end

  it "has a group" do
    expect(user.groups.first).to be_a(Group)
  end

  context "more users" do
    let!(:user2) { create(:user_wtc) }
    before do
      create(:user_121)
      create(:user_dbc)
      create(:user_138)
      create(:user_122)
      create(:user_134)
    end
    let!(:user3) { create(:user_130) }

    describe "#uniq_friends" do
      it "user has 6 friends" do
        expect(user.unique_friends.count).to eq(5)
      end

      it "user2 is a friend" do
        expect(user.unique_friends).to include(user2)
      end

      it "user3 is not a friend" do
        expect(user.unique_friends).not_to include(user3)
      end
    end

    describe "#is_friends_with" do
      it "user2 is a friend?" do
        expect(user.unique_friends_include?(user2)).to eq(true)
      end

      it "user3 is not a friend" do
        expect(user.unique_friends_include?(user3)).to eq(false)
      end
    end


    describe "#can_vote?" do
      it "user can't vote for itself" do
        expect(user.can_vote?(user)).to eq(false)
      end

      it "can vote for a user it hasn't voted for yet" do
        expect(user.can_vote?(user2)).to eq(true)
      end

      it "cannot vote for a user it has already voted for" do
        user2.drop_user_votes.create!(group_id: Group.first.id, voter_id: user.id)
        expect(user.can_vote?(user2)).to eq(false)
      end

      it "cannot vote for a non-friend" do
        expect(user.can_vote?(user3)).to eq(false)
      end
    end

    describe "#under_group_limit" do
      it "user is not under group limit" do
        expect(user.under_group_limit?).to eq(false)
      end

      it "user is under the limit when group dropped" do
        DropUser.new(Group.first, user).drop
        expect(user.under_group_limit?).to eq(true)
      end
    end
  end
end
