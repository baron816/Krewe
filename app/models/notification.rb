class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :notifiable, polymorphic: true
	belongs_to :message, ->{ where(notifications: {notifiable_type: "Message"}) }, foreign_key: 'notifiable_id'
	belongs_to :poster, class_name: 'User'

	delegate :name, to: :poster, prefix: true
	delegate :name, to: :group, prefix: true
	delegate :name, to: :notifiable, prefix: true
	delegate :group, to: :notifiable, prefix: true

	scope :unviewed_notifications, ->{ where(viewed: false) }
	scope :category_notifications, ->(category) { where(notifiable_type: category) }
	scope :poster_notifications, ->(poster) { where(poster_id: poster)}
	scope :notifiable_notifications, ->(id) { where(notifiable_id: id)}


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
		unviewed_category_notifications("PersonalMessage").poster_notifications(user)
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
		unviewed_category_notifications("Group").notifiable_notifications(group)
	end

	def self.unviewed_group_notification_count(group)
		group_count = unviewed_group_notifications_from_group(group).count + unviewed_message_notifications_from_group(group).count
		group_count if group_count > 0
	end

	def self.unviewed_message_notifications_from_group(group)
		unviewed_notifications.includes(:message).where("messages.group_id" => group)
	end

	def self.dismiss_group_notifications_from_group(group)
		group_notes = unviewed_group_notifications_from_group(group) + unviewed_message_notifications_from_group(group)
		group_notes.each(&:dismiss) if group_notes.any?
	end

	#activity

	def self.unviewed_activity_notifications(activity)
		unviewed_notifications.notifiable_notifications(activity)
	end

	def self.dismiss_activity_notification(activity)
		activity_note = unviewed_activity_notifications(activity).take
		activity_note.dismiss if activity_note
	end
end