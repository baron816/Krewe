require "rails_helper"

describe "Notification" do
	before do
		@user = create(:user_home)
		sleep(0.6)
	    @user2 = create(:user_wtc)
	    sleep(0.6)
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
		    Message.create(group: Group.first, user: @user, content: Faker::Lorem.sentence(5, true, 8))
		end

	  	it "new message creates notifications" do
	  		expect(Notification.count).to eql(5)
	  	end

	  	it "@user doesnt get notifications for its message" do
	  		expect(@user.active_notifications('Message').count).to eql(0)
	  	end

	  	it "@user2 gets notification for @users message" do
	  		expect(@user2.active_notifications('Message').count).to eql(1)
	  	end
  	end

  	context "personal message" do
  		before do
  			PersonalMessage.create(receiver: User.second, sender: @user, content: Faker::Lorem.sentence(5, true, 8))
  		end
  		
	  	it "new personal message creates notification" do
	  		expect(Notification.count).to eql(4)
	  	end
  	end
end