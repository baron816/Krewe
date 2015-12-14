class Message < ActiveRecord::Base
	belongs_to :poster, class_name: "User"
	belongs_to :messageable, polymorphic: true, touch: true
	has_many :notifications, as: :notifiable

	delegate :name, to: :poster, prefix: true
	delegate :users, :group, :is_friends_with?, to: :messageable, prefix: true
	delegate :group_includes_user?, to: :messageable

	validates :content, presence: true
	validates_presence_of :messageable, :messageable_type, :poster

	after_create :send_notifications

	scope :users_messages, -> { where(messageable_type: "User")  }
	scope :poster_messages,  -> (poster){ where(poster: poster)  }
	scope :messageable_messages, -> (poster){ where(messageable: poster)  }

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
	  @mentionted_users ||= content.scan(/\b(?<=data-name=\")[^"]+(?=\")/)
	end

	def send_mention_email_alerts
		send_to_users = mentioned_user_slugs.include?("group") ? messageable_users : messageable_users.users_by_slug(mentioned_user_slugs)

		GroupMailer.delay.mention_alert(self, send_to_users)
	end

	def send_notifications
		case messageable_type
		when 'Activity', 'Topic'
			send_group_or_activity_message_notifications
		when 'User'
			send_user_notification
		end
	end

	def send_group_or_activity_message_notifications
		messageable_users.each do |user|
			 create_notification(user) unless user == self.poster
		end
		send_mention_email_alerts
	end

	def send_user_notification
	  UserMailer.delay.user_message_alert(self) if !messageable.unviewed_personal_notifications_from_user_count(poster) && messageable.send_notification?('personal')
		create_notification(messageable)
	end

	def create_notification(user)
	  self.notifications.delay.create(user: user, poster: self.poster, notification_type: "#{messageable_type}Message")
	end
end
