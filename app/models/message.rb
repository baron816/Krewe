class Message < ActiveRecord::Base
	belongs_to :poster, class_name: "User"
	belongs_to :messageable, polymorphic: true
	has_many :notifications, as: :notifiable

	delegate :name, to: :poster, prefix: true
	delegate :users, to: :messageable, prefix: true

	validates :content, presence: true, length: { minimum: 3 }

	after_create :send_notifications

	scope :users_messages, -> { where(messageable_type: "User")  }
	scope :poster_messages,  -> (poster){ where(poster: poster)  }
	scope :messageable_messages, -> (poster){ where(messageable: poster)  }

	def self.messages_from_poster(poster)
	  users_messages.poster_messages(poster).messageable_messages(poster)
	end

	auto_html_for :content do
		image
		youtube
		link target: "_blank", rel: "nofollow"
		simple_format
	end

	def send_notifications
		case messageable_type
		when 'Group', 'Activity'
			messageable_users.each do |user|
				 create_notification(user) unless user == self.poster
			end
		when 'User'
			create_notification(messageable)
		end
	end

	private
	def create_notification(user)
	  self.notifications.create(user: user, poster: self.poster, notification_type: "#{messageable_type}Message")
	end
end
