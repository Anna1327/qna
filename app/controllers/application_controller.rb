class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit do |exception|
    redirect_to root_url, alert: exception.message
  end
end
