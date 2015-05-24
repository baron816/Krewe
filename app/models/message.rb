class Message < ActiveRecord::Base
	belongs_to :user
	belongs_to :group

	after_create do	
		send_notifications
	end

	def say
		self.group
	end
	
	def send_notifications
		self.group.users.each do |user|
			Notification.create(group_id: self.group.id, user_id: user.id, poster_id: self.user.id) unless user == self.user
		end
	end
end