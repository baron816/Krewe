require "rails_helper"

describe "Notification" do
	before do
		@user = create(:user_home)
	    @user2 = create(:user_wtc)
	    create(:user_121)
  	end

  	it "users joining group creates notifications" do
  		expect(Notification.count).to eql(3)
  	end

  	it "user has active_notifications (no parameter)" do
  		expect(@user.active_notifications.count).to eql(2)
  	end

  	it "user has active notifications for join" do
  		expect(@user.active_notifications('Join').count).to eql(2)
  	end

  	it "can dismiss all group notifications for a user" do
  		Group.first.dismiss_notifications(@user)
  		expect(@user.active_notifications('Join').count).to eql(0)
  	end

  	context "group message" do
		before do
		    Message.create(group: @user.groups.first, user: @user, content: Faker::Lorem.sentence(5, true, 8))
		end

	  	it "new message creates notifications" do
	  		expect(Notification.count).to eql(5)
	  	end

	  	it "@user doesnt get notifications for its message" do
	  		expect(@user.active_notifications('Group').count).to eql(0)
	  	end

  	end

  	context "personal message" do
  		before do
  			PersonalMessage.create(receiver: User.second, sender: @user, content: Faker::Lorem.sentence(5, true, 8))
  		end
  		
	  	it "new personal message creates notification" do
	  		expect(Notification.count).to eql(1)
	  	end
  	end
end