class ApplicationController < ActionController::API
  include Secured
  include ExceptionHandler

  def raise_not_found!
    raise ActionController::RoutingError, 'Route Not Found'
  end
end
