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

	after_create do
		find_or_create_group
	end

	geocoded_by :address

	after_validation :geocode

	def group_ids
		self.groups.any? ? self.groups.map { |group| group.id } : [-1]
	end

	def group_search
		Group.near(self, 0.5).where(can_join: true, category: self.category).where('id not in (?)', group_ids).take
	end

	def find_or_create_group
		group = group_search

		unless group.nil?
			self.groups << group
			group.check_space
			join_group_notifications(group)
		else
			Group.create(longitude: self.longitude, latitude: self.latitude, category: self.category).users << self
		end
	end

	def join_group_notifications(group)
		group.users.each do |user|
			Notification.create(group: group, user: user, poster: self, category: 'Join') unless user == self
		end
	end

	def active_notifications(category = ["Personal", "Message", "Join"])
		self.notifications.where(viewed: false, category: category).order(created_at: :desc).limit(3)
	end

	def personal_notifications(user)
		active_notifications("Personal").where(poster: user)
	end

	def dismiss_notifications(user)
		personal_notifications(user).each do |notification|
			notification.dismiss
		end
	end

	def show_personal_notifications(user)
		notifications = self.personal_notifications(user)
		notifications.count if notifications.count > 0
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
end