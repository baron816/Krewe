class Group < ActiveRecord::Base
	has_many :user_groups
	has_many :users, through: :user_groups
	has_many :messages
	has_many :notifications
	has_many :activities

	reverse_geocoded_by :latitude, :longitude

	before_create do
		name_group
	end

	def name_group
		self.name = Faker::Commerce.color.capitalize
	end


	def upcoming_activities
		activities.where('appointment > ?', Time.now).order(appointment: :asc)
	end

	def check_space
		self.can_join = false if users.count == user_limit
		save
	end

	def drop_user(user)
		users.delete(user)
		check_space
	end
	
	#notification methods

	def join_group_notifications(new_user)
		users.each do |user|
			Notification.create(group: self, user: user, poster: new_user, category: 'Join') unless user == new_user
		end
	end
	
	def unviewed_user_notifications(user)
		notifications.where(user: user, viewed: false)
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
		notification_count = user_notification_count(user)
		notification_count if notification_count > 0
	end
end