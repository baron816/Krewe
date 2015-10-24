class TopicsController < ApplicationController
  before_action :get_topic, except: :create
  before_action :get_group, only: :create

  def show
    @topic = TopicShow.new(@topic, params[:page])
    current_user.dismiss_topic_notifications_from_topic(@topic)
  end

  def change
    @topic = TopicShow.new(@topic, params[:page])
    current_user.dismiss_topic_notifications_from_topic(@topic)
  end

  def create
    @topic = @group.topics.new(group_params)

    @topic.save

    @topic_show = TopicShow.new(@topic, params[:page])

    respond_to do |format|
      format.html { redirect_to(@group) }
      format.js
    end
  end

  private
  def get_topic
    @topic = Topic.find(params[:id])
  end

  def get_group
    @group = Group.friendly.find(params[:group_id])
  end

  def group_params
    params.require(:topic).permit(:name)
  end
end
