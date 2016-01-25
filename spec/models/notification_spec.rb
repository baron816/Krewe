require "rails_helper"

describe "Notification" do
		let!(:user) { create(:user_home) }
    let!(:user2) { create(:user_wtc) }
    let!(:user3) { create(:user_121) }
    let!(:group) { Group.first }


  	it "users joining group creates notifications" do
			expect(Notification.count).to eql(3)
  	end

  	context "join notification" do
	  	it "user has active notifications for join" do
	  		expect(user.unviewed_group_notification_count(group)).to eql(2)
	  	end

	  	it "can dismiss all group notifications for a user" do
	  		user.dismiss_group_notifications_from_group(group)
	  		expect(user.unviewed_group_notification_count(group)).to eql(nil)
	  	end
  	end

  	context "group message" do
		before do
			create(:message, messageable: Topic.first, poster: user)
		end

	  	it "new message creates notifications" do
	  		expect(Notification.count).to eql(5)
	  	end

	  	it "user doesnt get notifications for its message" do
	  		expect(user.unviewed_category_notifications('TopicMessage').count).to eql(0)
	  	end

	  	it "user2 gets notification for users message" do
	  		expect(user2.unviewed_category_notifications('TopicMessage').count).to eql(1)
	  	end

	  	it "user2 can dismiss notification" do
	  		user2.dismiss_topic_notifications_from_topic(Topic.first)
	  		expect(user2.unviewed_category_notifications('TopicMessage').count).to eql(0)
	  	end

		  it "has a group name" do
		    expect(user2.unviewed_category_notifications('TopicMessage').first.group_name).to eq(group.name)
		  end
  	end

  	context "personal message" do
  		before do
				create(:message, poster: user, messageable: User.second)
  		end

	  	it "new personal message creates notification" do
	  		expect(Notification.count).to eql(4)
	  	end

	  	it "user doesn't receive notification from its message" do
	  		expect(user.unviewed_category_notifications('UserMessage').count).to eql(0)
	  	end

	  	it "user3 doesn't receive notification from message not sent to it" do
	  		expect(user3.unviewed_category_notifications('UserMessage').count).to eql(0)
	  	end

	  	it "user2 does receive notification from message" do
	  		expect(user2.unviewed_category_notifications('UserMessage').count).to eql(1)
	  	end

			it "user2 has unviewed notifications from user" do
				expect(user2.unviewed_personal_notifications_from_user_count(user)).to eql(1)
			end

	  	describe "dismiss_notifications" do
	  	  before do
					create(:message, messageable: User.second, poster: user3)
	  	  end

	  	  it "user2 can dismiss user's notification without dismissing user3's" do
	  	  	user2.dismiss_personal_notifications_from_user(user)
	  	  	expect(user2.unviewed_category_notifications('UserMessage').count).to eql(1)
	  	  end
	  	end
  	end

  	context "activity" do
  		let!(:activity) { create(:activity_future, group: group) }

  		it "creates a activity notifications" do
  			expect(user2.unviewed_category_notifications("Activity").count).to eql(1)
  		end

  		it "creates a notification for the second user" do
  			expect(user2.unviewed_category_notifications("Activity").count).to eql(1)
  		end

  		describe "dismiss_activity_notification" do
  		  it "dismisses the users activity notification" do
	  		  user2.dismiss_activity_notification(activity)
	  		  expect(user2.unviewed_category_notifications("Activity").count).to eql(0)
  		  end

  		  it "does not dismiss second users notification" do
  		  	expect(user2.unviewed_category_notifications("Activity").count).to eql(1)
  		  end
  		end

			context "activity message" do
				before do
				  activity.users << [user, user2, user3]
					create(:message, poster: user, messageable: activity)
				end

				it "does not send a notification to user" do
					expect(user.unviewed_category_notifications("ActivityMessage").count).to eq(0)
				end

				it "does send a notification to user2" do
				  expect(user2.unviewed_category_notifications("ActivityMessage").count).to eq(1)
				end
			end
  	end
end
