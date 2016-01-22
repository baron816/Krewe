require 'rails_helper'

describe ExpansionCheck do
  let(:group) { create(:old_group) }

  describe "#ripe_for_expansion" do
    it "does not indicate group is ripe for expansion" do
      expect(ExpansionCheck.new(group).ripe_for_expansion?).to eq(false)
    end

    it "is ripe for expansion with activities" do
      group.activities << create_list(:activity_past, 4)

      expect(ExpansionCheck.new(group).ripe_for_expansion?).to eq(true)
    end
  end

  describe "#ripe_and_voted?" do
    before do
      group.activities << create_list(:activity_past, 4)
      group.users << create_list(:user_home, 6)
    end

    it "group is ripe but has not voted" do
      expect(ExpansionCheck.new(group).ripe_for_expansion?).to eq(true)
      expect(ExpansionCheck.new(group).ripe_and_voted?).to eq(false)
    end
  end
end
