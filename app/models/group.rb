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
	scope :non_former_groups, ->(group_ids) { where.not(id: group_ids) }

	def self.search(params)
		self.open_groups.category_groups(params[:category]).near(params[:user], 0.5).excluded_users(params[:friend_ids]).non_former_groups(params[:group_ids])[0]
	end


	def check_space
		users_count = users.count
		if users_count == user_limit - 1
			self.can_join = true
			save
		elsif users_count == user_limit
			self.can_join = false
			save
		end
	end

	def drop_user(user)
		users.delete(user)
		user.add_dropped_group(id)
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
