require 'rails_helper'

describe User do
  it "factory creates a user" do
  	expect(create(:user_home)).to be_valid
  end

  context "User home" do
  	before do
    		sleep(0.6)
        @user = create(:user_home)
  	end

  	it "user home has address" do
  		expect(@user.address).to eq('135 William Street, New York, NY')
  	end  	

  	it "user home has longitude coordinate" do
  		expect(@user.longitude).to eq(-74.00671419999999)
  	end

  	it "user home has latitude coordinate" do
  		expect(@user.latitude).to eq(40.7094706)
  	end

    it "has a group" do
      expect(@user.groups.first).to be_a(Group)
    end

    describe "#find_or_create_group" do
      before do
        sleep(0.6)
        create(:user_wtc)
        sleep(0.6)
        create(:user_121)
        sleep(0.6)
        create(:user_dbc)
        sleep(0.6)
        create(:user_138)
        sleep(0.6)
        create(:user_122)
        sleep(0.6)
        create(:user_130)
        sleep(0.6)
        create(:user_134)
      end

      it "user's group only has six member" do
        expect(@user.groups.first.users.count).to eql(6)
      end

      it "user isn't put in a group it's already in" do
        @user.find_or_create_group
        expect(@user.groups.first).not_to eql(@user.groups.second)
      end
    end
  end

end