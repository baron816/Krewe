class UserPublicProfile
  def initialize(user, current_user)
    @user = user
    @current_user = current_user
  end

  delegate :name, :email, :category, :id, to: :user, prefix: true

  def user_location
    user.address.split(',')[1..-1].join(',')
  end

  def personal_messages
    t = Message.arel_table

    @messages ||= Message.where(t[:poster_id].in([user.id, current_user.id]).and(t[:messageable_id].in([user.id, current_user.id])))
  end

  def any_messages?
    personal_messages.any?
  end

  def new_message
    Message.new(messageable_id: user.id, poster_id: current_user, messageable_type: user.class)
  end

  def own_profile?
    @user == current_user
  end

  private
  attr_reader :user, :current_user
end
