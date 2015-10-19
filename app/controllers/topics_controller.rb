class TopicsController < ApplicationController
  before_action :get_topic

  def show
    @topic = TopicShow.new(@topic, params[:page])
  end

  def change
    @topic = TopicShow.new(@topic, params[:page])
  end

  private
  def get_topic
    @topic = Topic.find(params[:id])
  end
end
