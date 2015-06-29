class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	belongs_to :poster, class_name: 'User'

	delegate :name, to: :poster, prefix: true
	delegate :name, to: :group, prefix: true

	scope :unviewed_notifications, ->{ where(viewed: false) }
	scope :category_notifications, ->(category) { where(category: category) }

	scope :group_notifications, ->(group) { where(group: group) }

	def dismiss
		self.viewed = true if viewed == false
		save
	end

	def self.unviewed_categories(categories)
		unviewed_notifications.category_notifications(categories)
	end
end