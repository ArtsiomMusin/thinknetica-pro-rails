require "application_responder"

# frozen_string_literal: true
class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js do
        flash.now[:error] = exception.message
        render 'access_denied',  status: :forbidden
      end
      format.json { render json: { errors: [exception.message] }, status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  check_authorization unless: :devise_controller?

  # override it to let doorkeeper and cancan ot be used at the same time
  def current_user
    return User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    @current_user ||= warden.authenticate(scope: :user)
  end
end
