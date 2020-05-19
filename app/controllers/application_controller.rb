class ApplicationController < ActionController::API
  include Pagy::Backend
  include Secured
  include ExceptionHandler

  def raise_not_found!
    raise ActionController::RoutingError, 'Route Not Found'
  end
end
