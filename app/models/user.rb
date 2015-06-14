class User < ActiveRecord::Base
	validates :name, presence: true, length: { minimum: 3 }
	validates :email, presence: true, uniqueness: true
	validates :street, presence: true
	validates :city, presence: true
	validates :category, presence: true
	validates :password, presence: true, length: { minimum: 6 }

	has_secure_password
	has_many :user_groups
	has_many :groups, through: :user_groups
	has_many :messages
	has_many :notifications
	has_many :friends, through: :groups, source: :users
	has_many :personal_messages
	has_many :user_activities
	has_many :activities, through: :user_activities
	has_many :owned_activities, class_name: "Activity", foreign_key: "proposer_id"

	after_create do
		find_or_create_group
	end

	geocoded_by :address

	after_validation :geocode


	def friend_ids
		friends.any? ? friends.pluck(:id) : [-1]
	end

	def group_search
		Group.open_groups.category_groups(self.category).near(self, 0.5).excluded_users(friend_ids)[0]
	end

	def find_or_create_group
		group = group_search

		if group
			self.groups << group
			group.check_space
			group.join_group_notifications(self)
		else
			Group.create(longitude: longitude, latitude: latitude, category: category).users << self
		end
	end

	def upcoming_activities
		activities.where('appointment > ?', Time.now).order(appointment: :asc)
	end

	def unique_friends
		friends.uniq
	end


	def address
		[street, city, state].join(', ')
	end

	def birthday
		Date.new(birth_year, birth_month, birth_day)
	end

	def age
		now = Date.today
		now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
	end

	#notification methods

	def active_notifications(categories = ["Personal", "Message", "Join"])
		notifications.unviewed_notifications.category_notifications(categories).order(created_at: :desc).limit(3)
	end

	def render_divider?
		(active_notifications("Message").any? || active_notifications("Personal").any?) && active_notifications("Join").any?
	end

	def personal_notifications(user)
		active_notifications("Personal").where(poster: user)
	end

	def dismiss_personal_notifications(user)
		personal_notifications(user).each do |notification|
			notification.dismiss
		end
	end

	def show_personal_notifications(user)
		notifications = personal_notifications(user)
		notifications.count if notifications.count > 0
	end

	def unviewed_group_notifications(group)
		notifications.group_notifications(group).unviewed_notifications
	end

	def unviewed_group_notifications_count(group)
		unviewed_group_notifications(group).count
	end

	def dismiss_group_notifications(group)
		notifications = unviewed_group_notifications(group)
		if notifications.any?
			notifications.each do |notification|
				notification.dismiss
			end
		end
	end

	def show_group_notifications_count(group)
		notification_count = unviewed_group_notifications_count(group)
		notification_count if notification_count > 0
	end
end