class Activity < ActiveRecord::Base
	belongs_to :group
	belongs_to :proposer, class_name: "User"
	has_many :user_activities
	has_many :users, through: :user_activities

	validates :plan, presence: true, length: { minimum: 3 }
	validates :appointment, presence: true

	def user_going?(user)
		self.users.include?(user)
	end
end