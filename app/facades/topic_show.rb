class TopicShow
  attr_reader :this_topic, :page, :per_page, :user
  def initialize(topic, page, user)
    @this_topic = topic
    @user = user
    @page = page
    @per_page = 5
  end

  delegate :any?, to: :messages, prefix: true
  delegate :names_data, :id, to: :this_topic
  delegate :count, to: :found_messages, prefix: true
  delegate :next_page, to: :messages

  def messages
    @messages ||= this_topic.messages.includes(:poster).page(page).per(per_page).order(created_at: :desc)
  end

  def new_message
    @message ||= Message.new
  end

  def dismiss_notifications
    user.dismiss_topic_notifications_from_topic(this_topic)
  end
end
