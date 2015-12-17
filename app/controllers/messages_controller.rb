class MessagesController < ApplicationController
	def create
		@message = load_messageable.messages.new(message_params)
		authorize! :post, @message

		@message.save!

		respond_to do |format|
			format.html { redirect_to(current_user) }
			format.js
		end
	end

	def index
	  activity = Activity.find(params[:activity_id])
		@activity = ActivityShow.new(activity: activity, user: current_user, page: params[:page])
	end

	private
	def message_params
		params.require(:message).permit(:content).merge(poster_id: current_user.id)
	end

	def load_messageable
	  if params[:topic_id]
	  	@messageable = Topic.find(params[:topic_id])
		elsif params[:user_id]
			@messageable = User.friendly.find(params[:user_id])
	  elsif params[:activity_id]
			@messageable = Activity.find(params[:activity_id])
		end
	end
end
