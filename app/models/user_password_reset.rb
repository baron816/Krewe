class UserPasswordReset
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def send_password_reset
    user.generate_token(:password_reset_token)
    user.password_reset_sent_at = Time.zone.now
    user.save
    UserMailer.password_reset(user).deliver_now
  end

  def password_reset_expired?
		user.password_reset_sent_at < 1.hours.ago
	end
end
