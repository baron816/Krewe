require 'rails_helper'

describe ExpandGroupVotesController do
  let!(:user) { create(:user_home) }
  let!(:group) { Group.first}
  before do
    group.update_column(:created_at, Time.now - 2.months)
    log_in(user)
  end

  describe "POST #create" do
    context "when not expanding" do
      it "creates a new vote" do
        expect { post :create, group_id: group }.to change(ExpandGroupVote, :count).by(1)
      end

      it "does not create a new group" do
        expect { post :create, group_id: group }.to change(Group, :count).by(0)
      end
    end

    context "when expanding" do
      before do
        11.times do
          user = create(:user_home)
          group = user.groups.first

          ExpandGroupVote.create(group_id: group.id, voter_id: user.id)
        end

        @group2 = Group.second
        @group2.update_column(:created_at, Time.now - 1.month)

        4.times do
          group.activities.create(location: "South Street", appointment: Time.now - 1.month, proposer_id: user.id, plan: "drinks", well_attended: true)

          @group2.activities.create(location: "South Street", appointment: Time.now - 1.month, proposer_id: user.id, plan: "drinks", well_attended: true)
        end

        Groups::GroupSpaceCheck.new(group, user).check_space
        Groups::GroupSpaceCheck.new(@group2, user).check_space
      end

      it "starts with only two groups" do
        expect(Group.count).to eq(2)
      end

      it "both groups are ripe_for_expansion" do
        expect(Groups::ExpansionCheck.new(group).ripe_for_expansion?).to eq(true)
        expect(Groups::ExpansionCheck.new(@group2).ripe_for_expansion?).to eq(true)
      end

      it "group2 has voted to expand" do
        expect(Groups::ExpansionCheck.new(@group2).send(:voted_to_expand?)).to eq(true)
      end

      it "group has not voted to expand" do
        expect(Groups::ExpansionCheck.new(group).send(:voted_to_expand?)).to eq(false)
      end

      it "creates a new group when voting to expand and group2 has expanded" do
        Groups::ExpandGroup.new(@group2).expand_group
        expect { post :create, group_id: group }.to change(Group, :count).by(1)
      end
    end
  end
end
