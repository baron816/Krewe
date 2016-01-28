class Activity < ActiveRecord::Base
	belongs_to :group
	belongs_to :proposer, class_name: "User"
	has_many :user_activities
	has_many :users, through: :user_activities, after_add: :check_attendance, after_remove: :check_attendance
	has_many :notifications, as: :notifiable, dependent: :destroy
	has_many :messages, as: :messageable

	reverse_geocoded_by :latitude, :longitude

	before_create :add_proposer_to_users
	after_create { ActivityNotification.new(self).send_notifications }
	after_update { ActivityNotification.new(self, "ActivityUpdate").send_notifications }

	validates :plan, presence: true, length: { minimum: 3 }
	validates_presence_of :location, :appointment, :group_id, :proposer_id
	validate :is_a_time?

	delegate :name, :users, :users_include?, to: :group, prefix: true
	delegate :size, to: :users, prefix: true

	scope :future_activities, -> { where('appointment > ?', Time.now - 2.hours).order(appointment: :asc) }
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

	def check_attendance(user = nil)
		if users_size == 3 && self.well_attended != true
			self.well_attended = true
			save
		elsif users_size == 2 && self.well_attended != false
			self.well_attended = false
			save
		end
	end

	def proposed_by?(user)
		proposer == user
	end

	private
	def add_proposer_to_users
	  users << proposer
	end
end
