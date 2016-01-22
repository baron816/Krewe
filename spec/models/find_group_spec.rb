require "rails_helper"

describe FindGroup do
  let!(:user) { create(:user_home) }
  let!(:user2) { create(:user_wtc) }
  let!(:user3) { create(:user_130) }
  before do
    create(:user_121)
    create(:user_dbc)
    create(:user_138)
    create(:user_122)
    create(:user_134)
  end

  describe "#find_or_create_group" do

    it "user isn't put in a group it's already in" do
      FindGroup.new(user).find_or_create
      expect(user.groups.first).not_to eql(user.groups.second)
    end

    it "user2 only adds one group" do
      FindGroup.new(user2).find_or_create
      expect(user2.groups.count).to eql(2)
    end

    it "user2's second group is the same as first users group" do
      expect(user2.groups.second).to eq(user.groups.second)
    end
  end
end
