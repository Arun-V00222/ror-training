# frozen_string_literal: true

module Secured
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request! ,:except => [:register]
    before_action :set_current_user ,:except => [:register]
  end

  private

  def authenticate_request!
    auth_token = getAuthToken
    decoded_token = JsonWebToken.decode(auth_token)
    Rails.logger.info("Decoded Token: #{@decode_token}")
    @user_id = decoded_token[0]["user_id"]
    Rails.logger.info("user_id: #{@user_id}")
  rescue JWT::VerificationError, JWT::DecodeError
    raise CustomErrors::Unauthorized, 'Not Authenticated'
  end

  def getAuthToken
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    else
      Rails.logger.info("AuthToken is missing")
    end
  end

  def set_current_user(user_id = @user_id)
    Rails.logger.info("user_id: #{user_id}")
    user = User.where(id: user_id).first
    Rails.logger.info("User email:#{user.user_email}") if user.present?
    raise CustomErrors::Unauthorized, 'User not found' unless user.present?
    User.current_user = user
    Rails.logger.info("Currently logged in user id: #{User.current_user.id}, name: #{User.current_user.user_name}, email: #{User.current_user.user_email}")
  rescue StandardError => e
    Rails.logger.error(e.message)
    raise CustomErrors::Unauthorized, 'Not Authenticated'
  end

end
