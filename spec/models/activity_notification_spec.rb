require 'rails_helper'

describe ActivityNotification do
  let!(:user1) { create(:user_home) }
  let!(:user2) { create(:user_wtc) }
  let!(:user3) { create(:user_121) }
  let!(:group) { Group.first }

  let!(:activity) { Activity.create(group_id: Group.first.id, proposer_id: user1.id, appointment: (Time.now + 1.week), plan: "do stuff", location: "Seaport" ) }

  describe "#send_notifications" do
    context "propose activity" do
      it "sends 'Activity' notification types" do
        expect(Notification.last.notification_type).to eq("Activity")
      end

      it "sends notifications to group users" do
        expect(user2.unviewed_activity_create_notifications_from_group(group).count).to eq(1)
        expect(user3.unviewed_activity_create_notifications_from_group(group).count).to eq(1)
      end

      it "doesn't send notifications to proposer" do
          expect(user1.unviewed_activity_create_notifications_from_group(group).count).to eq(0)
      end
    end

    context "update activity" do
      before do
        Activity.first.update(plan: "Drink up")
      end

      it "sends 'ActivityUpdate' notification types" do
        expect(Notification.last.notification_type).to eq("ActivityUpdate")
      end

      it "sends notifications to group users" do
        expect(user2.unviewed_category_notifications("ActivityUpdate").count).to eq(1)
        expect(user3.unviewed_category_notifications("ActivityUpdate").count).to eq(1)
      end

      it "still doesn't send notifications to proposer" do
          expect(user1.unviewed_activity_create_notifications_from_group(group).count).to eq(0)
      end
    end
  end
end
