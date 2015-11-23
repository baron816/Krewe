class TopicShow
  attr_reader :this_topic, :page, :per_page, :user
  def initialize(topic, page, current_user)
    @this_topic = topic
    @page = page
    @user = current_user
    @per_page = per_page || 0 > 5 ? per_page : 5
  end

  delegate :any?, to: :messages, prefix: true
  delegate :names_data, :id, to: :this_topic
  delegate :count, to: :found_messages, prefix: true
  delegate :next_page, to: :messages

  def messages
    @messages ||= this_topic.messages.page(page).per(per_page).order(created_at: :desc)
  end

  def new_message
    @message ||= Message.new
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
