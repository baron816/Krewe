class Message < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	has_many :notifications, as: :notifiable

	delegate :name, to: :user, prefix: true
	delegate :name, to: :group, prefix: true
	delegate :users, to: :group, prefix: true

	validates :content, presence: true, length: { minimum: 3 }

	after_create do
		send_notifications
	end

	def send_notifications
		group_users.each do |user|
			self.notifications.create(user: user, poster: self.user) unless user == self.user
		end
	end
end
