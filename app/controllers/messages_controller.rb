class MessagesController < ApplicationController
	before_action :user_logged?

	def create
		@message = Message.new(message_params)

		@message.save!

		respond_to do |format|
			format.html { redirect_to(current_user) }
			format.js
		end
	end

	private
	def message_params
		params.require(:message).permit(:content, :messageable_id, :messageable_type, :poster_id)
	end
end
