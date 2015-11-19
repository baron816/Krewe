class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :notifiable, polymorphic: true
	belongs_to :message, ->{ where(notifications: {notifiable_type: "Message"}) }, foreign_key: 'notifiable_id'
	belongs_to :activity, ->{ where(notifications: { notifiable_type: "Activity" }) }, foreign_key: 'notifiable_id'
	belongs_to :poster, class_name: 'User'

	delegate :name, to: :poster, prefix: true

	default_scope -> { includes(:poster) }

	scope :unviewed_notifications, ->{ where(viewed: false) }
	scope :category_notifications, ->(category) { where(notification_type: category) }
	scope :poster_notifications, ->(poster) { where(poster_id: poster)}
	scope :notifiable_notifications, ->(id) { where(notifiable_id: id)}

	def self.show_notifications
	  unviewed_category_notifications(["TopicMessage", "UserMessage", "Join", "ActivityMessage"]) + unviewed_future_activity_notifications(["Activity", "ActivityUpdate"])
	end

	def self.show_notifications_count
	  show_notifications.count
	end

	def self.poster_sorted_category_notifications(category)
	  unviewed_category_notifications(category).group_by(&:poster_name)
	end

	def group_name
	  notifiable.messageable_group.name
	end

	def dismiss
		self.viewed = true if viewed == false
		save
	end

	def self.unviewed_notifications_count
		unviewed_notifications.count
	end

	def self.unviewed_category_notifications(category)
		unviewed_notifications.category_notifications(category)
	end

	#personal

	def self.unviewed_personal_notifications_from_user(user)
		unviewed_category_notifications("UserMessage").poster_notifications(user)
	end

	def self.unviewed_personal_notifications_from_user_count(user)
		personal_count = unviewed_personal_notifications_from_user(user).count
		personal_count if personal_count > 0
	end

	def self.dismiss_personal_notifications_from_user(user)
		personal_notes = unviewed_personal_notifications_from_user(user)
		personal_notes.each(&:dismiss) if personal_notes.any?
	end

	#group

	def self.unviewed_group_notifications_from_group(group)
		unviewed_category_notifications("Join").notifiable_notifications(group.id)
	end

	def self.unviewed_group_notification_count(group)
		group_count = unviewed_group_notifications_from_group(group).count + unviewed_message_notifications_from_group(group).count + unviewed_activity_create_notifications_from_group(group).count
		group_count if group_count > 0
	end

	def self.unviewed_message_notifications_from_group(group)
		unviewed_notifications.includes(:message).where("messages.messageable_id" => group.topics_ids)
	end

	def self.dismiss_group_notifications_from_group(group)
		group_notes = unviewed_group_notifications_from_group(group)
		group_notes.each(&:dismiss) if group_notes.any?
	end

	def self.unviewed_message_notifications_from_topic(topic)
	  unviewed_notifications.includes(:message).where("messages.messageable_id" => topic.id)
	end

	def self.unviewed_message_notifications_from_topic_count(topic)
	  count = unviewed_message_notifications_from_topic(topic).count
	 	count if count > 0
	end

	def self.dismiss_topic_notifications_from_topic(topic)
	  topic_notes = unviewed_message_notifications_from_topic(topic)
		topic_notes.each(&:dismiss) if topic_notes.any?
	end
	#activity
	def self.unviewed_future_activity_notifications(category)
	  unviewed_category_notifications(category).includes(:activity).where("activities.appointment" => [DateTime.now..DateTime.now + 10.years])
	end

	def self.unviewed_activity_create_notifications_from_group(group)
	  unviewed_category_notifications("Activity").includes(:activity).where("activities.group_id" => group.id).where("activities.appointment" => [DateTime.now..DateTime.now + 10.years])
	end

	def self.unviewed_activity_message_notifications(activity)
	  unviewed_notifications.includes(:message).where("messages.messageable_id" => activity.id)
	end

	def self.unviewed_activity_update_notifications_from_activity(activity)
	  unviewed_category_notifications("ActivityUpdate").notifiable_notifications(activity)
	end

	def self.unviewed_activity_notifications_count(activity)
	  count = unviewed_activity_message_notifications(activity).count + unviewed_activity_update_notifications_from_activity(activity).count
		count if count > 0
	end

	def self.unviewed_activity_notifications(activity)
		unviewed_notifications.notifiable_notifications(activity)
	end

	def self.dismiss_activity_notification(activity)
		activity_notes = unviewed_activity_notifications(activity) + unviewed_activity_update_notifications_from_activity(activity) + unviewed_activity_message_notifications(activity)
		activity_notes.each(&:dismiss) if activity_notes.any?
	end
end
