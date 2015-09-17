class User < ActiveRecord::Base
	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	validates :name, presence: true, length: { minimum: 3, maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
	validates :password, presence: true, length: { minimum: 6 }, on: :create
	validates_presence_of :longitude, :latitude, :address, :category

	has_secure_password
	has_many :user_groups
	has_many :groups, through: :user_groups
	has_many :messages, as: :messageable
	has_many :notifications
	has_many :friends, through: :groups, source: :users
	has_many :personal_messages
	has_many :user_activities
	has_many :activities, through: :user_activities
	has_many :owned_activities, class_name: "Activity", foreign_key: "proposer_id"
	has_many :drop_user_votes
	has_many :expand_group_votes

	after_create :find_or_create_group
	before_create { generate_token(:auth_token) }
	before_save :downcase_email

	after_validation :geocode
	reverse_geocoded_by :latitude, :longitude

	def find_or_create_group
		group = Group.search(category: category, friend_ids: friends.ids, latitude: latitude, longitude: longitude, group_ids: dropped_group_ids)

		if group
			self.groups << group
			group.check_space
			group.join_group_notifications(self)
		else
			group = self.groups.create(longitude: longitude, latitude: latitude, category: category)
		end
		group
	end

	def update_sign_in(ip)
		self.last_sign_in_at = Time.now
		self.sign_in_count += 1
		self.last_sign_in_ip = ip
		save
	end

	def unique_friends
		friends.where.not(id: self).uniq
	end

	def future_activities
	  activities.future_activities.includes(:group)
	end

	def add_dropped_group(id)
		dropped_group_ids << id
		save
	end

	def group_drop_votes_count(group)
		drop_user_votes.group_votes(group).count
	end

	def not_self(user)
		self != user
	end

	def has_not_voted?(user)
		drop_user_votes.has_not_voted?(user)
	end

	def can_vote?(user)
		not_self(user) && user.has_not_voted?(self)
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

	def send_password_reset
		generate_token(:password_reset_token)
		self.password_reset_sent_at = Time.zone.now
		save
		UserMailer.password_reset(self).deliver_now
	end

	def password_reset_expired?
		password_reset_sent_at < 1.hours.ago
	end

	def first_name
	  name.split.first
	end

	def under_group_limit?
	  groups.count < group_limit
	end

	private
	def slug_candidates
	  [
			:name,
			[:slug_hex]
		]
	end

	def slug_hex
		slug = normalize_friendly_id(name)
		begin
			hexed = "#{slug}-#{SecureRandom.hex(3)}"
		end while User.exists?(slug: hexed)
		hexed
	end

	def should_generate_new_friendly_id?
	  :name_changed? || super
	end

	def downcase_email
		self.email = email.downcase
	end
end
