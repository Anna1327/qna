class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :unauthorized_user

  private

  def unauthorized_user(exception)
    respond_to do |format|
      format.html do
        flash[:alert] = exception.message
        redirect_to root_path
      end
      format.json { render json: [t('pundit.unauthorized')], status: :unauthorized }
      format.js { render json: [t('pundit.unauthorized')], status: :unauthorized }
    end
  end
end
