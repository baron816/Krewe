require "rails_helper"

describe "Notification" do
	before do
		@user = create(:user_home)
	    create(:user_wtc)
	    create(:user_121)
  	end

  	it "users joining group creates notifications" do
  		expect(Notification.count).to eql(3)
  	end

  	it "new message creates notifications" do
	    @message = Message.create(group: @user.groups.first, user: @user, content: Faker::Lorem.sentence(5, true, 8))
  		expect(Notification.count).to eql(5)
  	end
end