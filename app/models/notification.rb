class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	belongs_to :poster, class_name: 'User'

	def dismiss
		self.viewed = true if viewed == false
		save
	end
end