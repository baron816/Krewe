class MessagesController < ApplicationController
	def create
		@message = Message.new(message_params)

		@message.save

		respond_to do |format|
			format.html { redirect_to(@message.group) }
			format.js
		end
		
	end

	private
	def message_params
		params.require(:message).permit(:content, :group_id, :user_id)
	end
end