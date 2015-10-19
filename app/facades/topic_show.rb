class TopicShow
  attr_reader :this_topic, :page, :per_page
  def initialize(topic, page)
    @this_topic = topic
    @page = page
    @per_page = 5
  end

  delegate :any?, to: :messages, prefix: true
  delegate :names_data, :id, to: :this_topic
  delegate :count, to: :found_messages, prefix: true

  def messages
    @messages ||= found_messages.page(page).per(per_page).order(created_at: :desc)
  end

  def found_messages
    @found_messages ||= this_topic.messages.includes(:poster)
  end

  def new_message
    @message ||= Message.new
  end

  def multiple_pages?
    found_messages_count > per_page
  end
end