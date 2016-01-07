class BetaCode < ActiveRecord::Base
  include Tokenable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255}, format: { with: VALID_EMAIL_REGEX }

  before_create { generate_token(:auth_token) }
  after_create { UserMailer.delay.beta_code(self) }
end
