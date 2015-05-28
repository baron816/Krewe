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

	def user_notification_count(user)
		self.notifications.where(user: user, viewed: false).count
	end

	def dismiss_notifications(user)
		self.notifications.where(user: user).each do |notification|
			notification.dismiss
		end
	end

	def show_group_notifications(user)
		notification_count = self.user_notification_count(user)
		notification_count if notification_count > 0
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