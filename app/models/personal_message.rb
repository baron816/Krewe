class PersonalMessage < ActiveRecord::Base
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'

	after_create do
		send_notification
	end

	def send_notification
		Notification.create(user: self.receiver, poster: self.sender, category: "Personal")
	end
end