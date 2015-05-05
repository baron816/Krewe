require 'rails_helper'

describe User do
  it "factory creates a user" do
  	expect(create(:user)).to be_valid
  end


  context "User home" do
  	before do
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
  end

end