# frozen_string_literal: true

class CustomLogger
  def initialize(error)
    @error = error
    Rails.logger.error @error.message
    Rails.logger.error @error.backtrace
  end

  def log_to_newrelic
    #NewRelic::Agent.notice_error(@error)
  end
end
