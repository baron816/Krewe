class TopicsController < ApplicationController
  before_action :get_topic, except: :create
  before_action :set_topic_show, except: :create
  before_action :get_group, only: :create

  def show
  end

  def change
  end

  def create
    @topic = @group.topics.new(group_params)
    authorize! :create, @topic

    @topic.save!

    set_topic_show

    respond_to do |format|
      format.html { redirect_to(@group) }
      format.js
    end
  end

  private
  def get_topic
    @topic = Topic.find(params[:id])
  end

  def set_topic_show
    @topic = TopicShow.new(@topic, params[:page], current_user)
  end

  def get_group
    @group = Group.friendly.find(params[:group_id])
  end

  def group_params
    params.require(:topic).permit(:name)
  end
end
