class TopicsController < ApplicationController
  before_action :get_topic, except: :create

  def show
  end

  def change
  end

  def create
    group = Group.friendly.find(params[:group_id])
    topic = group.topics.new(group_params)
    authorize! :create, topic

    topic.save!

    set_topic_show(topic)

    respond_to do |format|
      format.html { redirect_to(group) }
      format.js
    end
  end

  private
  def get_topic
    topic = Topic.find(params[:id])
    set_topic_show(topic)
  end

  def set_topic_show(topic)
    @topic = TopicShow.new(topic, params[:page], current_user)
  end

  def group_params
    params.require(:topic).permit(:name)
  end
end
