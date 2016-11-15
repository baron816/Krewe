require 'rails_helper'

describe Groups::ExpansionCheck do
  let(:group) { create(:old_group) }


  describe "#ripe_for_expansion" do
    it "does not indicate group is ripe for expansion" do
      expect(Groups::ExpansionCheck.new(group).ripe_for_expansion?).to eq(false)
    end

    it "is ripe for expansion with activities" do
      create_list(:activity_past, 4, :well_attended, group: group)

      expect(Groups::ExpansionCheck.new(group).ripe_for_expansion?).to eq(true)
    end
  end

  describe "#ripe_and_voted?" do
    before do
      create_list(:activity_past, 4, :well_attended, group: group)
      group.users << create_list(:user_home, 6)
    end

    it "group is ripe but has not voted" do
      expect(Groups::ExpansionCheck.new(group).ripe_for_expansion?).to eq(true)
      expect(Groups::ExpansionCheck.new(group).ripe_and_voted?).to eq(false)
    end
  end
end
