class Message < ActiveRecord::Base
	belongs_to :user
	belongs_to :group

	validates :content, presence: true, length: { minimum: 3 }

	after_create do	
		send_notifications
	end
	
	def send_notifications
		self.group.users.each do |user|
			Notification.create(group: self.group, user: user, poster: self.user, category: 'Message') unless user == self.user
		end
	end
end