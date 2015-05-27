class PersonalMessagesController < ApplicationController
	before_filter :find_personal_message

	

	private
	def find_personal_message
		@personal_message = PersonalMessages.find(params[:id]) if params[:id]
	end
end