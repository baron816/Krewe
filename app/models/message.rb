class Message < ActiveRecord::Base
	belongs_to :poster, class_name: "User"
	belongs_to :messageable, polymorphic: true, touch: true
	has_many :notifications, as: :notifiable

	delegate :name, to: :poster, prefix: true
	delegate :users, to: :messageable, prefix: true

	validates :content, presence: true, length: { minimum: 2 }
	validates_presence_of :messageable, :messageable_type, :poster

	after_create :send_notifications, :send_mention_email_alerts

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

	def self.personal_messages(first_user, second_user)
		t = Message.arel_table

		Message.where(t[:poster_id].in([first_user.id, second_user.id]).and(t[:messageable_id].in([first_user.id, second_user.id])), messageable_type: "User").order(created_at: :desc)
	end

	private
	def mentioned_user_slugs
	  content.scan(/\b(?<=data-name=\")[^"]+(?=\")/)
	end

	def send_mention_email_alerts
	  User.users_by_slug(mentioned_user_slugs).each do |user|
	    UserMailer.mention_alert(self, user).deliver_now
	  end
	end

	def send_notifications
		case messageable_type
		when 'Group', 'Activity'
			messageable_users.each do |user|
				 create_notification(user) unless user == self.poster
			end
		when 'User'
			create_notification(messageable)
			UserMailer.user_message_alert(self).deliver_now
		end
	end

	def create_notification(user)
	  self.notifications.create(user: user, poster: self.poster, notification_type: "#{messageable_type}Message")
	end
end
