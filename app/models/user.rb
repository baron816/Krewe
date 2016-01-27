class User < ActiveRecord::Base
	extend FriendlyId
	include Sluggable
	include Tokenable
	friendly_id :slug_candidates, use: :slugged

	validates :longitude, :latitude, :address, :category, :age_group, presence: true, on: :update
	validates :terms_of_service, acceptance: true

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

	after_update { find_group if sign_up_complete_changed? }
	before_update { self.sign_up_complete = true unless sign_up_complete? }
	before_create { generate_token(:auth_token) }

	after_validation :geocode
	reverse_geocoded_by :latitude, :longitude

	delegate :unviewed_notifications, :dismiss_personal_notifications_from_user, :unviewed_personal_notifications_from_user_count, :unviewed_group_notification_count, :dismiss_group_notifications_from_group, :unviewed_category_notifications, :dismiss_activity_notification, :unviewed_activity_notifications_count, :unviewed_activity_message_notifications_count, :unviewed_message_notifications_from_topic_count, :dismiss_topic_notifications_from_topic, :unviewed_activity_create_notifications_from_group, :poster_sorted_category_notifications, :unviewed_future_activity_notifications, :show_notifications_count, :show_notifications_positive?, to: :notifications
	delegate :group_drop_votes_count, :voter_vote, to: :drop_user_votes
	delegate :future_activities, to: :activities
	delegate :count, to: :groups, prefix: true
	delegate :degree_groups, to: :groups
	delegate :include?, :count, to: :unique_friends, prefix: true

	scope :users_by_slug, -> (slugs) { where(slug: slugs)  }

	def self.create_with_omniauth(auth)
		create! do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.name = auth.info.name
			user.email = auth.info.email
			user.photo_url = auth.info.image
		end
	end

	def unique_friends
		@unique_friends ||= friends.where.not(id: self).uniq
	end

	def can_unvote?(user)
		self != user && user.voter_vote(self) && self.unique_friends_include?(user)
	end

	def can_vote?(user)
		self != user && !user.voter_vote(self) && self.unique_friends_include?(user)
	end

	def under_group_limit?
	  groups_count < group_limit
	end

	def city
	  address.split(',')[1..-1].join(',')
	end

	def send_notification?(type)
	   notification_settings[type].nil? || notification_settings[type].to_bool
	end

	def find_group
	  FindGroup.new(self).find_or_create
	end
end
