# frozen_string_literal: true

module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern
  included do
    rescue_from Exception, with: :internal_server_error
    rescue_from CustomErrors::ResponseError, with: :handle_custom_errors
    rescue_from ActionController::UnpermittedParameters, with: :bad_request_error
    rescue_from ActionController::ParameterMissing, with: :bad_request_error
    rescue_from ActionController::RoutingError, with: :routing_error

    private

    def render_error_json(message = '', status = :bad_request)
      render json: { error: { message: message } }, status: status
    end

    def handle_custom_errors(e)
      Rails.logger.error e.message
      render_error_json(e.message, e.code)
    end

    def bad_request_error(e)
      Rails.logger.error e.message
      render_error_json 'invalid params'
    end

    def routing_error(e)
      render_error_json 'No routes matched', :not_found
    end

    def internal_server_error(e)
      CustomLogger.new(e).log_to_newrelic
      render_error_json 'Something went wrong', :internal_server_error
    end

    def user_not_authorized
      render_error_json 'User not authorized', :forbidden
    end
  end
end
