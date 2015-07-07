class Group < ActiveRecord::Base
	has_many :user_groups
	has_many :users, through: :user_groups
	has_many :messages
	has_many :notifications, as: :notifiable
	has_many :activities
	has_many :drop_user_votes

	reverse_geocoded_by :latitude, :longitude

	before_create do
		name_group
	end

	scope :open_groups, -> { where(can_join: true) }
	scope :category_groups, ->(category) { where(category: category) }
	scope :excluded_users, ->(friend_ids) { includes(:users).where("users.id not in (?)", friend_ids).references(:users) }

	def self.search(category, friend_ids, user)
		self.open_groups.category_groups(category).near(user, 0.5).excluded_users(friend_ids)[0]
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
		self.delete if users.empty?
	end

	def kick_user(user)
		drop_user(user) if user.group_drop_votes_count(self) >= 3
	end
	
	#notification methods

	def join_group_notifications(new_user)
		users.each do |user|
			self.notifications.create(user: user, poster: new_user) unless user == new_user
		end
	end

	private
	def name_group
		self.name = Faker::Commerce.color.capitalize
	end
end