class MessagesController < ApplicationController
	before_action :user_logged?

	def create
		@message = load_messageable.messages.new(message_params)

		@message.save!

		respond_to do |format|
			format.html { redirect_to(current_user) }
			format.js
		end
	end

	private
	def message_params
		params.require(:message).permit(:content).merge(poster_id: current_user.id)
	end

	def load_messageable
	  if params[:group_id]
	  	@messageable = Group.friendly.find(params[:group_id])
		elsif params[:user_id]
			@messageable = User.friendly.find(params[:user_id])
	  elsif params[:activity_id]
			@messageable = Activity.find(params[:activity_id])
		end
	end
end
