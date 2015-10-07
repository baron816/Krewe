require 'rails_helper'

describe Activity do
  before do
    @user1 = create(:user_home)
		@user2 = create(:user_wtc)
    @user3 = create(:user_121)

    @activity = Activity.create(group_id: Group.first.id, proposer_id: @user1.id, appointment: (Time.now + 1.week), plan: "do stuff", location: "Seaport" )
  end

  it "created @activity" do
    expect(@activity).to be_an(Activity)
  end

  it "doesn't have any users" do
    expect(@activity.users.size).to eq(0)
  end

  it "is not well attended" do
    @activity.check_attendance
    expect(@activity.well_attended).to eq(false)
  end

  describe "#user_going?" do
    it "@user is not going" do
      expect(@activity.user_going?(@user1)).to eq(false)
    end

    it "@user is going when its going" do
      @activity.users << @user1
      expect(@activity.user_going?(@user1)).to eq(true)
    end
  end

  describe "#proposed_by?" do
    it "was not proposed by user2" do
      expect(@activity.proposed_by?(@user2)).to eq(false)
    end

    it "was proposed by user1" do
      expect(@activity.proposed_by?(@user1)).to eq(true)
    end
  end

  describe "#group_includes_user?" do
    it "includes @user1 and @user2" do
      expect(@activity.group_includes_user?(@user1)).to eq(true)
    end

    it "does not include a user not in the group" do
      @user4 = create(:user_stucco)
      expect(@activity.group_includes_user?(@user4)).to eq(false)
    end
  end

  describe "#check_attendance" do
    before do
      @activity.users << [@user1, @user2]
      @activity.check_attendance
    end

    it "has users" do
      expect(@activity.users.size).to eq(2)
    end

    it "is still not well attended" do
      expect(@activity.well_attended).to eq(false)
    end

    it "is well attended when another user is added" do
      @activity.users << @user3
      @activity.check_attendance
      expect(@activity.well_attended).to eq(true)
    end

    it "is not well attended if someone drops out" do
      @activity.users.delete(@user3)
      @activity.check_attendance
      expect(@activity.well_attended).to eq(false)
    end
  end

  describe "#attended_activities" do
    before do

      @activity2 = Activity.create(group_id: Group.first.id, proposer_id: @user1.id, appointment: (Time.now - 1.week), plan: "do things", location: "Seaport" )

      @activity2.users << [@user1, @user2]
    end

    it "does not have any had_attended_activities" do
      expect(Activity.attended_activities.size).to eq(0)
    end

    it "has had_attended_activities once user is added" do
      @activity2.users << @user3
      @activity2.check_attendance

      expect(Activity.attended_activities.size).to eq(1)
    end
  end

end
