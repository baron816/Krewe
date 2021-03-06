require 'rails_helper'

describe Groups::GroupSpaceCheck do
  before do
    create_list(:user_home, 8)
  end
  let!(:group){ Group.first }

  describe "#check_space" do
    it "eight users exist" do
      expect(User.count).to eq(8)
    end

    it "only put six users in the first group" do
      expect(group.users_count).to eq(6)
    end

    it "sets group can join to false" do
      expect(group.can_join).to eq(false)
    end

    context "after dropping user" do
      before do
        DropUser.new(group, group.users.first).drop
      end

      it "sets can join to true" do
        expect(Group.first.can_join).to eq(true)
      end

      it "puts new user in group" do
        new_user = create(:user_home)
        expect(Group.first.users).to include(new_user)
        expect(Group.count).to eq(2)
      end
    end
  end
end
