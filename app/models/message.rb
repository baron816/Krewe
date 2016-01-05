class Message < ActiveRecord::Base
	belongs_to :poster, class_name: "User"
	belongs_to :messageable, polymorphic: true, touch: true
	has_many :notifications, as: :notifiable

	delegate :name, to: :poster, prefix: true
	delegate :users, :group, :is_friends_with?, to: :messageable, prefix: true
	delegate :group_includes_user?, to: :messageable

	validates :content, presence: true
	validates_presence_of :messageable, :messageable_type, :poster

	after_create { MessageNotifications.new(self).send_notifications }

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
end
