class Activity < ActiveRecord::Base
	belongs_to :group
	belongs_to :proposer, class_name: "User"
	has_many :user_activities
	has_many :users, through: :user_activities

	geocoded_by :location

	after_validation :geocode

	validates :plan, presence: true, length: { minimum: 3 }
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
end