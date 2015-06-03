class PersonalMessage < ActiveRecord::Base
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'

	after_create do
		send_notification
	end

	def send_notification
		Notification.create(user: self.receiver, poster: self.sender, category: "Personal")
	end

	def self.users_messages(params = {})
		users = [params[:first_user], params[:second_user]]
		where(sender: users).where(receiver: users).order(created_at: :desc)
	end
end