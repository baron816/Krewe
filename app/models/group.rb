class Group < ActiveRecord::Base
	has_many :user_groups
	has_many :users, through: :user_groups
	has_many :messages
	has_many :notifications
	has_many :activities

	before_create do
		name_group
	end

	def name_group
		self.name = Faker::Commerce.color.capitalize
	end

	def unviewed_user_notifications(user)
		self.notifications.where(user: user, viewed: false)
	end

	def user_notification_count(user)
		unviewed_user_notifications(user).count
	end

	def dismiss_notifications(user)
		notifications = unviewed_user_notifications(user)
		if notifications.any?
			notifications.each do |notification|
				notification.dismiss
			end
		end
	end

	def show_group_notifications(user)
		notification_count = self.user_notification_count(user)
		notification_count if notification_count > 0
	end

	def upcoming_activities
		activities.where('appointment > ?', Time.now).order(appointment: :asc)
	end

	def check_space
		self.can_join = self.users.count < self.user_limit
		save
	end

	def drop_user(user)
		users.delete(user)
		check_space
	end

	reverse_geocoded_by :latitude, :longitude
end