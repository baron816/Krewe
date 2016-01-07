require 'rails_helper'

describe ExpandGroup do
  before do
    6.times do
      create(:user_home)
    end
    6.times do
      create(:user_wtc)
    end
    6.times do
      create(:user_stucco)
    end
  end

  let!(:group1) { Group.first }
  let!(:group2) { Group.second }
  let!(:group3) { Group.third }
  let!(:expander) { ExpandGroup.new(group1) }

  describe "#find_mergeable_group" do
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
      expect(ExpandGroup.new(group3).send(:find_mergeable_group)).to be_nil
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
        expect(expander.send(:merge_groups)).to eq(Group.fourth)
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
        expect(Group.fourth.notifications.count).to eq(0)
      end
    end

    describe "#expand_group" do
      it "returns a new group" do
        expect(expander.expand_group).to eq(Group.fourth)
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
end
