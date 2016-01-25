class TopicShow
  attr_reader :this_topic, :page, :user

  def initialize(topic, page, current_user)
    @this_topic = topic
    @page = page
    @user = current_user
  end

  delegate :any?, to: :messages, prefix: true
  delegate :name, :group, :id, to: :this_topic
  delegate :next_page, to: :messages

  def messages
    @messages ||= this_topic.messages.page(page).per(per_page).order(created_at: :desc)
  end

  def new_message
    Message.new(poster_id: user.id)
  end

  def names_data
    MentionName.new(this_topic.group, user).names_data
  end

  private
  def per_page
    note_count = user.unviewed_message_notifications_from_topic_count(this_topic)
    dismiss_notifications
    (note_count || 0) >= 5 ? note_count : 5
  end

  def dismiss_notifications
    user.dismiss_topic_notifications_from_topic(this_topic)
  end
end
