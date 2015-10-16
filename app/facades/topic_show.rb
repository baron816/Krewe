class TopicShow
  attr_reader :this_topic, :page, :per_page
  def initialize(topic, page)
    @this_topic = topic
    @page = page
    @per_page = 5
  end

  delegate :any?, to: :messages, prefix: true
  delegate :names_data, to: :this_topic

  def messages
    @messages ||= this_topic.messages.includes(:poster).page(page).per(per_page).order(created_at: :desc)
  end

  def new_message
    @message ||= Message.new
  end
end
