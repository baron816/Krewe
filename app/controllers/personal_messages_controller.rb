class PersonalMessagesController < ApplicationController
	def create
		@personal_message = PersonalMessage.new(personal_message_params)

		@personal_message.save
		respond_to do |format|
			format.html { redirect_to user_public_profile_path(@personal_message.receiver) }
			format.js
		end
	end

	private
	def personal_message_params
		params.require(:personal_message).permit(:content, :sender_id, :receiver_id)
	end
end