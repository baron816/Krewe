class Activity < ActiveRecord::Base
	belongs_to :group
	belongs_to :proposer, class_name: "User"
	has_many :user_activities
	has_many :users, through: :user_activities
	has_many :notifications, as: :notifiable

	geocoded_by :location

	after_validation :geocode

	before_save :fix_time

	after_create :send_notifications

	validates :plan, presence: true, length: { minimum: 3 }
	validates :location, presence: true
	validates :appointment, presence: true
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

	def fix_time
		self.appointment -= Time.now.utc_offset if appointment
	end

	def send_notifications
		group.users.each do |user|
			self.notifications.create(user: user, poster: self.proposer)
		end
	end

	def proposed_by?(user)
		proposer == user
	end
end