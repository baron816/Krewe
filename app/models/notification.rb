class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	belongs_to :poster, class_name: 'User'

	delegate :name, to: :poster, prefix: true
	delegate :name, to: :group, prefix: true

	def dismiss
		self.viewed = true if viewed == false
		save
	end
end