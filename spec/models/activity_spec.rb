require 'rails_helper'

describe Activity do
  before do
    @user1 = create(:user_home)
		@user2 = create(:user_wtc)
    @user3 = create(:user_121)

    @activity = Activity.create(group_id: Group.first, proposer_id: @user1, appointment: (Time.now + 1.week), plan: "do stuff" )
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

end
