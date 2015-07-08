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

	geocoded_by :address

	after_validation :geocode

	def group_search
		Group.open_groups.category_groups(self.category).near(self, 0.5).excluded_users(friend_ids)[0]
	end

	def find_or_create_group
		group = Group.search(category, friend_ids, self)

		if group
			self.groups << group
			group.check_space
			group.join_group_notifications(self)
		else
			Group.create(longitude: longitude, latitude: latitude, category: category).users << self
		end
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

	#notification methods

	def active_notifications
		notifications.unviewed_notifications
	end

	def active_notifications_count
		active_notifications.count
	end

	def active_notifications_category(category)
		notifications.unviewed_category_notifications(category)
	end

	def personal_notifications(user)
		notifications.unviewed_personal_notifications_from_user(user)
	end

	def personal_notifications_count(user)
		note_count = personal_notifications(user).count
		note_count if note_count > 0
	end

	def group_notifications(group)
		notifications.unviewed_group_notifications_from_group(group)
	end

	def group_notifications_count(group)
		group_count = group_notifications(group).count + group_message_notifications(group).count
		group_count if group_count > 0
	end

	def group_message_notifications(group)
		notifications.unviewed_message_notifications_from_group(group)
	end

	def dismiss_activity_notification(activity)
		note = notifications.unviewed_activity_notifications(activity).take
		note.dismiss if note
	end

	def dismiss_personal_notifications(user)
		personal_notes = personal_notifications(user)
		if personal_notes.any?
			personal_notes.each do |notification|
				notification.dismiss
			end
		end
	end

	def dismiss_group_notifications(group)
		group_notes = group_notifications(group) + group_message_notifications(group)
		if group_notes.any?
			group_notes.each do |notification|
				notification.dismiss
			end
		end
	end
	
	private
	def friend_ids
		friends.any? ? friends.pluck(:id) : [-1]
	end
end