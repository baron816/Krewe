class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :notifiable, polymorphic: true
	belongs_to :poster, class_name: 'User'

	delegate :name, to: :poster, prefix: true
	delegate :name, to: :group, prefix: true

	scope :unviewed_notifications, ->{ where(viewed: false) }
	scope :category_notifications, ->(category) { where(notifiable_type: category) }
	scope :poster_notifications, ->(poster) { where(poster_id: poster)}
	scope :notifiable_notifications, ->(id) { where(notifiable_id: id)}


	def dismiss
		self.viewed = true if viewed == false
		save
	end

	def self.unviewed_personal_notifications_from_user(user)
		unviewed_notifications.category_notifications("PersonalMessage").poster_notifications(user)
	end

	def self.unviewed_category_notifications(category)
		unviewed_notifications.category_notifications(category)
	end

	def self.unviewed_group_notifications_from_group(group)
		unviewed_notifications.notifiable_notifications(group.id)
	end

	def self.message_group_user
		unviewed_notifications.category_notifications("Message")
	end
end