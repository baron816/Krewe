require 'rails_helper'

describe DropUser do
  let!(:user) { create(:user_home) }
  let!(:group) { Group.first }

  describe "#drop" do

    context "only one user in group" do
      it "deletes the group" do
        DropUser.new(group, user).drop
        expect(Group.count).to eq(0)
      end
    end

    context "multiple users" do
      let!(:user2) { create(:user_home) }
      before do
        DropUser.new(group, user).drop
      end

      it "removes the user" do
        expect(Group.count).to eq(1)
      end

      it "removes the first user" do
        expect(group.users).not_to include(user)
      end
    end
  end

  describe "#remember_dropped_group_id" do
    it "user doesn't start with any dropped_user_groups" do
      expect(user.dropped_group_ids).to be_empty
    end

    it "adds dropped group id to dropped group ids array" do
      DropUser.new(group, user).drop
      expect(user.dropped_group_ids).to include(group.id)
    end
  end
end
