class CheckPasswordComplexityService
  include PasswordHelper
  attr_reader :password, :required_complexity, :errors

  def initialize(password, errors)
    @password = password
    @required_complexity = required_complexity
    @errors = errors
  end

  def password_errors
    run_checks
  end

  private
  def run_checks
    check_presence
    check_length
    check_commonality
  end

  def check_presence
    if password.nil?
      errors.add :password, "cannot be blank"
    end
  end

  def check_length
    if password.size < 6
      errors.add :password, "must be at least 6 characters long"
    end
  end

  def check_commonality
    if PasswordHelper::COMMON_PASSWORDS.include?(password.downcase)
      errors.add :password, "is too common. Hackers will easily crack it."
    end
  end
end
