class Api::V1::MessagesController < ApplicationController
  include Authenticable

  respond_to :json

  def create
    message = Message.new(message_params)

    if message.save
      render json: message, status: 201
    else
      render json: { errors: message.errors }, response: 422
    end
  end

  private
  def message_params
    params.require(:message).permit(:content, :messageable_id, :messageable_type, :poster_id)
  end
end
