class UserPasswordReset
  attr_reader :user, :time

  def initialize(user, time = Time.zone.now)
    @user = user
    @time = time
  end

  def send_password_reset
    user.generate_token(:password_reset_token)
    user.password_reset_sent_at = time
    user.save
    UserMailer.password_reset(user).deliver_now
  end

  def password_reset_expired?
		user.password_reset_sent_at < 1.hours.ago
	end
end
