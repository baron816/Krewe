class PersonalMessage < ActiveRecord::Base
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'
	has_many :notifications, as: :notifiable

	delegate :name, to: :sender, prefix: true

	after_create do
		send_notification
	end

	def send_notification
		self.notifications.create(user: receiver, poster: sender)
	end

	def self.users_messages(params = {})
		users = [params[:first_user], params[:second_user]]
		where(sender: users).where(receiver: users).order(created_at: :desc)
	end
end