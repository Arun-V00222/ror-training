class User < ApplicationRecord

  has_secure_password

  validate :password_match?

  validates :user_email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :user_name, format: { with: /\A[a-zA-Z0-9]+\Z/ }

  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x

  validates :password,
    presence: true,
    format: { with: PASSWORD_FORMAT }

  USER_JSON_PARAMS = { only: [
    :id, :user_name, :user_email]
  }.freeze

  def as_json(options = {})
    params = USER_JSON_PARAMS
    params = params.merge(options) if options.present?
    super(params)
  end


  def password_match?
    'Password must match Confirmation Password' if password!=password_confirmation
  end

#
#  def password_criteria_match?
#    'Password criteria is not satisfied' if !password.match(PASSWORD_FORMAT)
#  end
#
end
