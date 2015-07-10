# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
  	user = User.first
  	user.generate_token(:password_reset_token)
  	user.password_reset_sent_at = Time.zone.now
  	user.save
    UserMailer.password_reset(user)
  end

end
