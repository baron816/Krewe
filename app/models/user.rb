class User < ActiveRecord::Base
	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	validates :name, presence: true, length: { minimum: 3, maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
	validates :password, presence: true, length: { minimum: 6 }, on: :create
	validates_presence_of :longitude, :latitude, :address, :category, :age_group
	validate :multiple_words?

	has_secure_password
	has_many :user_groups
	has_many :groups, through: :user_groups
	has_many :posted_messages, class_name: "Message", foreign_key: "poster_id", dependent: :destroy
	has_many :messages, as: :messageable
	has_many :notifications, dependent: :destroy
	has_many :friends, through: :groups, source: :users
	has_many :user_activities
	has_many :activities, through: :user_activities
	has_many :owned_activities, class_name: "Activity", foreign_key: "proposer_id", dependent: :destroy
	has_many :drop_user_votes, dependent: :destroy
	has_many :votes_to_drop, class_name: "DropUserVote", foreign_key: "voter_id", dependent: :destroy
	has_many :expand_group_votes, foreign_key: "voter_id", dependent: :destroy
	has_many :posted_notifications, class_name: "Notification", foreign_key: "poster_id", dependent: :destroy

	after_create :find_or_create_group
	before_create { generate_token(:auth_token) }
	before_save :downcase_email

	after_validation :geocode
	reverse_geocoded_by :latitude, :longitude

	delegate :unviewed_notifications, :unviewed_notifications_count, :dismiss_personal_notifications_from_user, :unviewed_personal_notifications_from_user_count, :unviewed_group_notification_count, :dismiss_group_notifications_from_group, :unviewed_category_notifications, :dismiss_activity_notification, :unviewed_activity_notifications_count, :unviewed_message_notifications_from_topic_count, :dismiss_topic_notifications_from_topic, to: :notifications
	delegate :has_not_voted?, :group_drop_votes_count, :voter_vote, to: :drop_user_votes
	delegate :future_activities, to: :activities
	delegate :count, to: :groups, prefix: true
	delegate :degree_groups, to: :groups
	delegate :delete_all, to: :votes_to_drop, prefix: true

	scope :users_by_slug, -> (slugs) { where(slug: slugs)  }

	def find_or_create_group
		group = Group.search(category: category, age_group: age_group, friend_ids: friends.ids, latitude: latitude, longitude: longitude, group_ids: dropped_group_ids)

		if group
			group.users << self
		else
			group = self.groups.create(longitude: longitude, latitude: latitude, category: category, age_group: age_group)
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
		@unique_friends ||= friends.where.not(id: self).uniq
	end

	def unique_friends_count
	  unique_friends.count
	end

	def is_friends_with?(user)
	  unique_friends.include?(user)
	end

	def add_dropped_group(id)
		dropped_group_ids << id
		save
	end

	def not_self(user)
		self != user
	end

	def can_vote?(user)
		not_self(user) && !user.voter_vote(self) && self.is_friends_with?(user)
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
	  groups_count < group_limit
	end

	private
	def slug_candidates
	  [
			:name,
			[:slug_hex]
		]
	end

	def multiple_words?
	  unless name.split.count > 1
			errors.add(:name, "must include at first and last")
		end
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
