class UpdateEmail
  include ActiveModel::Validations

  attr_accessor :user
  attr_reader :email

  def initialize(user, email)
    @user = user
    @email = email
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255}, format: { with: VALID_EMAIL_REGEX }

  def update
    user.email = email

    if valid?
      user.update_column(:email, email)
      UserMailer.confirm_email(user).deliver_now
      true
    else
      false
    end
  end
end
