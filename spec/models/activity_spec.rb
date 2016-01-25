require 'rails_helper'

describe Activity do
  let!(:user1) { create(:user_home) }
	let!(:user2) { create(:user_wtc) }
  let!(:user3) { create(:user_121) }

  let!(:activity) { create(:activity_future, group: Group.first, proposer: user1) }

  it "created activity" do
    expect(activity).to be_an(Activity)
  end

  it "proposer is a user" do
    expect(activity.users).to include(user1)
  end

  it "is not well attended" do
    expect(activity.well_attended).to eq(false)
  end

  describe "#user_going?" do
    it "@user is not going" do
      expect(activity.user_going?(user2)).to eq(false)
    end

    it "user2 is going when its going" do
      activity.users << user2
      expect(activity.user_going?(user2)).to eq(true)
    end
  end

  describe "#proposed_by?" do
    it "was not proposed by user2" do
      expect(activity.proposed_by?(user2)).to eq(false)
    end

    it "was proposed byuser1" do
      expect(activity.proposed_by?(user1)).to eq(true)
    end
  end

  describe "#group_users_include?" do
    it "includes user1 and user2" do
      expect(activity.group_users_include?(user1)).to eq(true)
    end

    it "does not include a user not in the group" do
      user4 = create(:user_stucco)
      expect(activity.group_users_include?(user4)).to eq(false)
    end
  end

  describe "#check_attendance" do
    before do
      activity.users << user2
    end

    it "has users" do
      expect(activity.users.size).to eq(2)
    end

    it "is still not well attended" do
      expect(activity.well_attended).to eq(false)
    end

    it "is well attended when another user is added" do
      activity.users << user3
      expect(activity.well_attended).to eq(true)
    end

    it "is not well attended if someone drops out" do
      activity.users.delete(user3)
      expect(activity.well_attended).to eq(false)
    end
  end

  describe "#attended_activities" do
    let(:activity2) { create(:activity_past, group: Group.first, proposer: user1) }

    before do
      activity2.users << user2
    end

    it "does not have any had_attended_activities" do
      expect(Activity.attended_activities.size).to eq(0)
    end

    it "has had_attended_activities once user is added" do
      activity2.users << user3

      expect(Activity.attended_activities.size).to eq(1)
    end
  end

end
