class Activity < ActiveRecord::Base
	belongs_to :group
	belongs_to :proposer, class_name: "User"
	has_many :user_activities
	has_many :users, through: :user_activities
	has_many :notifications, as: :notifiable
	has_many :messages, as: :messageable

	reverse_geocoded_by :latitude, :longitude

	after_create :send_notifications
	after_update do
		send_notifications("ActivityUpdate")
	end

	validates :plan, presence: true, length: { minimum: 3 }
	validates_presence_of :location, :appointment, :group_id, :proposer_id
	validate :is_a_time?

	delegate :name, :users, :includes_user?, to: :group, prefix: true

	scope :future_activities, -> { where('appointment > ?', Time.now).order(appointment: :asc) }
	scope :past_activities, -> { where('appointment < ?', Time.now) }
	scope :attended_activities, -> { past_activities.where( well_attended: true ) }
	scope :attended_activities_count, -> { attended_activities.size }

	def user_going?(user)
		users.include?(user)
	end

	def is_a_time?
		unless appointment.is_a?(Time)
			errors.add(:appointment, "must be a time")
		end
	end

	def send_notifications(type = self.class.name)
		group_users.each do |user|
			unless user == proposer
				self.notifications.create(user: user, poster: self.proposer, notification_type: type)
				GroupMailer.delay.activity_proposal(user, self) if type == "Activity"
			end
		end
	end

	def check_attendance
	  users_count = users.size

		if users_count == 3 && self.well_attended != true
			self.well_attended = true
			save
		elsif users_count == 2 && self.well_attended != false
			self.well_attended = false
			save
		end
	end

	def proposed_by?(user)
		proposer == user
	end
end
