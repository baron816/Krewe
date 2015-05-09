class MessagesController < ApplicationController
	def create
		@message = current_user.messages.new(message_params)

		if @message.save
			redirect_to(@message.group)
		else
			render :new
		end
	end

	private
	def message_params
		params.require(:message).permit(:content, :group_id)
	end
end