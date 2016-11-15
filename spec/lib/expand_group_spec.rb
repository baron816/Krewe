require 'rails_helper'

describe Groups::ExpandGroup do
  before do
    create_list(:user_home, 6)
    create_list(:user_wtc, 6)
  end

  let!(:group1) { Group.first }
  let!(:group2) { Group.second }
  let!(:expander) { Groups::ExpandGroup.new(group1) }


  describe "#find_mergeable_group" do
    before do
      create_list(:user_stucco, 6)
    end
    let!(:group3) { Group.third }

    it "not find a group since none are ready" do
      expect(expander.send(:find_mergeable_group)).to be_nil
    end

    it "finds group2 when it's ready" do
      group2.update_column(:ready_to_expand, true)
      expect(expander.send(:find_mergeable_group)).to eq(group2)
    end

    it "will not allow group 3 to find other groups" do
      group1.update_column(:ready_to_expand, true)
      group2.update_column(:ready_to_expand, true)
      expect(Groups::ExpandGroup.new(group3).send(:find_mergeable_group)).to be_nil
    end
  end

  context "Second group ready to expand" do
    before do
      group2.update_column(:ready_to_expand, true)
    end

    describe "#mean_coordinates" do
      it "averages the coordinates between groups" do
        expect(expander.send(:mean_coordinates)).to_not eq({longitude: group1.longitude, latitude: group1.latitude})
      end
    end

    describe "#set_expanded" do
      it "sets group1.has_expanded to true" do
        expander.send(:set_expanded)
        expect(group1.has_expanded).to eq(true)
      end
    end

    describe "#set_ready_to_expand_to_false" do
      it "sets group2.ready_to_expand to false" do
        expander.send(:set_ready_to_expand_to_false)
        expect(Group.second.ready_to_expand).to eq(false)
      end
    end

    describe "#merge_groups" do
      it "creates a new group" do
        expect(expander.send(:merge_groups)).to eq(Group.third)
      end

      it "has 12 users" do
        expect(expander.send(:merge_groups).users_count).to eq(12)
      end

      it "sets second group to not ready to expand" do
        expander.send(:merge_groups)
        expect(Group.second.ready_to_expand).to eq(false)
      end

      it "does not send new notifications" do
        expander.send(:merge_groups)
        expect(Group.third.notifications.count).to eq(0)
      end
    end

    describe "#expand_group" do
      it "returns a new group" do
        expect(expander.expand_group).to eq(Group.third)
      end

      it "sets the group to expanded" do
        expander.expand_group
        expect(group1.has_expanded).to eq(true)
      end
    end
  end

  context "second group not ready to expand" do
    describe "#expand_group" do
      it "returns nil" do
        expect(expander.expand_group).to be_nil
      end

      it "sets ready_to_expand to true" do
        expander.expand_group
        expect(group1.ready_to_expand).to eq(true)
      end
    end
  end

  context "third degree group" do
    before do
      create_list(:user_home, 12)

      Group.find_each do |group|
        Groups::ExpandGroup.new(group).expand_group
      end
    end
    let(:group5) { Group.last(2).first }
    let(:group6) { Group.last }

    it "has 6 groups" do
      expect(Group.count).to eq(6)
    end

    it "last two groups are second degree groups" do
      expect(group5.degree).to eq(2)
      expect(group6.degree).to eq(2)
    end

    it "makes last two groups with 12 members each" do
      expect(group5.users_count).to eq(12)
      expect(group6.users_count).to eq(12)
    end

    context "another expansion" do
      before do
        Groups::ExpandGroup.new(group5).expand_group
      end
      let(:group7) { Groups::ExpandGroup.new(group6).expand_group }

      it "creates a new group from the last two" do
        expect(group7).to be_a(Group)
      end

      it "has new group with 24 users" do
        expect(group7.users_count).to eq(24)
      end

      it "has a degree of 3" do
        expect(group7.degree).to eq(3)
      end

      it "does not create a new group when expanding group 7" do
        expect(Groups::ExpandGroup.new(group7).expand_group).to be_nil
      end
    end
  end
end
