class Activity < ActiveRecord::Base
	belongs_to :group
	belongs_to :proposer, class_name: "User"
	has_many :user_activities
	has_many :users, through: :user_activities
	has_many :notifications, as: :notifiable

	reverse_geocoded_by :latitude, :longitude

	after_create :send_notifications

	validates :plan, presence: true, length: { minimum: 3 }
	validates_presence_of :location, :appointment, :group_id, :proposer_id
	validate :is_a_time?

	delegate :name, to: :group, prefix: true

	scope :future_activities, -> { where('appointment > ?', Time.now) }

	def user_going?(user)
		users.include?(user)
	end

	def is_a_time?
		unless appointment.is_a?(Time)
			errors.add(:appointment, "must be a time")
		end
	end

	def send_notifications
		group.users.each do |user|
			self.notifications.create(user: user, poster: self.proposer) unless user == proposer
		end
	end

	def proposed_by?(user)
		proposer == user
	end
end
