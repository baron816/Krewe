class MessagesController < ApplicationController
	def create
		@message = Message.new(message_params)

		@message.save
		redirect_to(@message.group)
	end

	private
	def message_params
		params.require(:message).permit(:content, :group_id, :user_id)
	end
end