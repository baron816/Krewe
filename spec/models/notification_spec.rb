require "rails_helper"

describe "Notification" do
	before do
			@user = create(:user_home)
	    @user2 = create(:user_wtc)
	    @user3 = create(:user_121)
	    @group = Group.first
  	end

  	it "users joining group creates notifications" do
  		expect(Notification.count).to eql(3)
  	end

  	it "user has unviewed_notifications" do
  		expect(@user.notifications.unviewed_notifications.count).to eql(2)
  	end

  	context "join notification" do
	  	before do
	  	  @notifications = @user.notifications
	  	end

	  	it "user has active notifications for join" do
	  		expect(@notifications.unviewed_category_notifications('Group').count).to eql(2)
	  	end

	  	it "can dismiss all group notifications for a user" do
	  		@notifications.dismiss_group_notifications_from_group(@group)
	  		expect(@notifications.unviewed_category_notifications('Group').count).to eql(0)
	  	end
  	end

  	context "group message" do
		before do
		    Message.create(group: Group.first, user: @user, content: Faker::Lorem.sentence(5, true, 8))
			@user_notifications = @user.notifications
			@user2_notifications = @user2.notifications
		end

	  	it "new message creates notifications" do
	  		expect(Notification.count).to eql(5)
	  	end

	  	it "@user doesnt get notifications for its message" do
	  		expect(@user_notifications.unviewed_category_notifications('Message').count).to eql(0)
	  	end

	  	it "@user2 gets notification for @users message" do
	  		expect(@user2_notifications .unviewed_category_notifications('Message').count).to eql(1)
	  	end

	  	it "@user2 can dismiss notification" do
	  		@user2_notifications .dismiss_group_notifications_from_group(Group.first)
	  		expect(@user2_notifications .unviewed_category_notifications('Message').count).to eql(0)
	  	end
  	end

  	context "personal message" do
  		before do
  			PersonalMessage.create(receiver: User.second, sender: @user, content: Faker::Lorem.sentence(5, true, 8))
  			@user_notifications = @user.notifications
  			@user2_notifications = @user2.notifications
  			@user3_notifications = @user3.notifications
  		end

	  	it "new personal message creates notification" do
	  		expect(Notification.count).to eql(4)
	  	end

	  	it "@user doesn't receive notification from its message" do
	  		expect(@user_notifications.unviewed_category_notifications('PersonalMessage').count).to eql(0)
	  	end

	  	it "@user3 doesn't receive notification from message not sent to it" do
	  		expect(@user3_notifications.unviewed_category_notifications('PersonalMessage').count).to eql(0)
	  	end

	  	it "@user2 does receive notification from message" do
	  		expect(@user2_notifications.unviewed_category_notifications('PersonalMessage').count).to eql(1)
	  	end

	  	describe "dismiss_notifications" do
	  	  before do
	  	    PersonalMessage.create(receiver: User.second, sender: @user3, content: Faker::Lorem.sentence(5, true, 8))
	  	  	@user2_notifications = @user2.notifications
	  	  end

	  	  it "@user2 can dismiss @user's notification without dismissing @user3's" do
	  	  	@user2_notifications.dismiss_personal_notifications_from_user(@user)
	  	  	expect(@user2_notifications.unviewed_category_notifications('PersonalMessage').count).to eql(1)
	  	  end
	  	end
  	end

  	context "activity" do
  		before do
  		  @activity = Activity.create(group_id: @group.id, plan: "go somewhere", appointment: Time.now, proposer_id: @user.id, location: "World Trade Center")
				@notifications = @user2.notifications
  		end

  		it "creates a activity notifications" do
  			expect(@notifications.unviewed_category_notifications("Activity").count).to eql(1)
  		end

  		it "creates a notification for the second user" do
  			expect(@notifications.unviewed_category_notifications("Activity").count).to eql(1)
  		end

  		describe "dismiss_activity_notification" do
  		  it "dismisses the users activity notification" do
	  		  @notifications.dismiss_activity_notification(@activity)
	  		  expect(@notifications.unviewed_category_notifications("Activity").count).to eql(0)
  		  end

  		  it "does not dismiss second users notification" do
  		  	expect(@notifications.unviewed_category_notifications("Activity").count).to eql(1)
  		  end
  		end
  	end
end
