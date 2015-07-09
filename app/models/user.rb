class User < ActiveRecord::Base
	validates :name, presence: true, length: { minimum: 3 }
	validates :email, presence: true, uniqueness: true
	validates :street, presence: true
	validates :city, presence: true
	validates :category, presence: true
	validates :password, presence: true, length: { minimum: 6 }, on: :create

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
	has_many :drop_user_votes

	after_create do
		find_or_create_group
	end

	before_create { generate_token(:auth_token) }

	geocoded_by :address

	after_validation :geocode

	def find_or_create_group
		group = Group.search(category, friend_ids, self)

		if group
			self.groups << group
			group.check_space
			group.join_group_notifications(self)
		else
			group = Group.create(longitude: longitude, latitude: latitude, category: category)
			group.users << self
		end
		group	
	end

	def upcoming_activities
		activities.future_activities.order(appointment: :asc)
	end

	def update_sign_in(ip)
		self.last_sign_in_at = Time.now
		self.sign_in_count += 1
		self.last_sign_in_ip = ip
		save
	end

	def unique_friends
		friends.uniq
	end


	def address
		[street, city, state].join(', ')
	end

	def group_drop_votes_count(group)
		drop_user_votes.group_votes(group).count
	end

	def not_self(user)
		self != user
	end

	def can_vote?(user)
		not_self(user) && user.drop_user_votes.voter_votes(self).empty?
	end

	def voter_vote(user)
		votes = drop_user_votes(user).take
		votes if votes
	end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end
	
	private
	def friend_ids
		friends.any? ? friends.pluck(:id) : [-1]
	end
end